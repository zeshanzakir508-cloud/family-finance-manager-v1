import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing biometric authentication.
class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final SharedPreferences _prefs;

  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _biometricAttemptsKey = 'biometric_attempts';
  static const String _biometricLockedKey = 'biometric_locked';
  static const String _biometricLockoutTimeKey = 'biometric_lockout_time';

  BiometricService(this._prefs);

  /// Checks if biometric authentication is available on the device.
  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      return isAvailable;
    } catch (e) {
      return false;
    }
  }

  /// Checks if biometric authentication is enabled for the app.
  Future<bool> isBiometricEnabled() async {
    return _prefs.getBool(_biometricEnabledKey) ?? false;
  }

  /// Enables biometric authentication for the app.
  Future<void> enableBiometric() async {
    await _prefs.setBool(_biometricEnabledKey, true);
    await _resetAttempts();
  }

  /// Disables biometric authentication for the app.
  Future<void> disableBiometric() async {
    await _prefs.remove(_biometricEnabledKey);
    await _resetAttempts();
  }

  /// Authenticates the user using biometrics.
  Future<bool> authenticate({
    required String reason,
    bool stickyAuth = true,
  }) async {
    // Check if biometrics are available
    final isAvailable = await isBiometricAvailable();
    if (!isAvailable) return false;

    // Check if biometrics are enabled
    final isEnabled = await isBiometricEnabled();
    if (!isEnabled) return false;

    // Check if biometrics are locked
    if (await _isBiometricLocked()) {
      return false;
    }

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: stickyAuth,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        await _resetAttempts();
      } else {
        await _incrementAttempts();
      }

      return authenticated;
    } catch (e) {
      await _incrementAttempts();
      return false;
    }
  }

  /// Gets the available biometric types.
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Returns true if biometric lock is active.
  Future<bool> _isBiometricLocked() async {
    final locked = _prefs.getBool(_biometricLockedKey) ?? false;
    if (!locked) return false;

    // Check if lockout time has passed
    final lockoutTime = _prefs.getString(_biometricLockoutTimeKey);
    if (lockoutTime != null) {
      try {
        final lockoutDateTime = DateTime.parse(lockoutTime);
        final duration = DateTime.now().difference(lockoutDateTime);
        if (duration >= const Duration(minutes: 15)) {
          // Lockout has expired
          await _resetAttempts();
          return false;
        }
      } catch (e) {
        // Invalid timestamp, reset
        await _resetAttempts();
        return false;
      }
    }

    return true;
  }

  /// Increments the biometric attempt counter.
  Future<void> _incrementAttempts() async {
    final attempts = _prefs.getInt(_biometricAttemptsKey) ?? 0;
    final newAttempts = attempts + 1;

    await _prefs.setInt(_biometricAttemptsKey, newAttempts);

    // Lock after 3 failed attempts
    if (newAttempts >= 3) {
      await _prefs.setBool(_biometricLockedKey, true);
      await _prefs.setString(
        _biometricLockoutTimeKey,
        DateTime.now().toIso8601String(),
      );
    }
  }

  /// Resets the biometric attempt counter.
  Future<void> _resetAttempts() async {
    await _prefs.remove(_biometricAttemptsKey);
    await _prefs.remove(_biometricLockedKey);
    await _prefs.remove(_biometricLockoutTimeKey);
  }

  /// Returns the remaining lockout time.
  Future<Duration?> getLockoutRemaining() async {
    if (!(await _isBiometricLocked())) return null;

    final lockoutTime = _prefs.getString(_biometricLockoutTimeKey);
    if (lockoutTime == null) return null;

    try {
      final lockoutDateTime = DateTime.parse(lockoutTime);
      final elapsed = DateTime.now().difference(lockoutDateTime);
      final remaining = const Duration(minutes: 15) - elapsed;
      return remaining > Duration.zero ? remaining : Duration.zero;
    } catch (e) {
      return null;
    }
  }

  /// Checks if biometric authentication is supported and enabled.
  Future<bool> isAvailableAndEnabled() async {
    final isAvailable = await isBiometricAvailable();
    if (!isAvailable) return false;
    return await isBiometricEnabled();
  }
}
