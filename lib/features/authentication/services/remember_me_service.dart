import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert' as convert;

import '../models/remember_me_model.dart';

/// Service for managing "Remember Me" functionality.
class RememberMeService {
  static const String _rememberMeKey = 'remember_me_data';
  static const String _rememberMeEnabledKey = 'remember_me_enabled';

  final SharedPreferences _prefs;

  RememberMeService(this._prefs);

  /// Saves user credentials for "Remember Me".
  Future<void> saveCredentials({
    required String email,
    required String password,
    String? userId,
    String? deviceId,
  }) async {
    final encryptedPassword = _encryptPassword(password);

    final model = RememberMeModel.saveCredentials(
      email: email,
      encryptedPassword: encryptedPassword,
      userId: userId,
      deviceId: deviceId,
    );

    final json = jsonEncode({
      'email': model.email,
      'encryptedPassword': model.encryptedPassword,
      'userId': model.userId,
      'deviceId': model.deviceId,
      'enabled': model.enabled,
      'lastLoginAt': model.lastLoginAt?.toIso8601String(),
    });

    await _prefs.setString(_rememberMeKey, json);
    await _prefs.setBool(_rememberMeEnabledKey, true);
  }

  /// Saves a remember me token.
  Future<void> saveToken({
    required String email,
    required String token,
    String? userId,
    String? deviceId,
  }) async {
    final model = RememberMeModel.withToken(
      email: email,
      token: token,
      userId: userId,
      deviceId: deviceId,
    );

    final json = jsonEncode({
      'email': model.email,
      'token': model.token,
      'userId': model.userId,
      'deviceId': model.deviceId,
      'enabled': model.enabled,
      'lastLoginAt': model.lastLoginAt?.toIso8601String(),
    });

    await _prefs.setString(_rememberMeKey, json);
    await _prefs.setBool(_rememberMeEnabledKey, true);
  }

  /// Gets the stored "Remember Me" data.
  Future<RememberMeModel?> getCredentials() async {
    final enabled = _prefs.getBool(_rememberMeEnabledKey) ?? false;
    if (!enabled) return null;

    final jsonString = _prefs.getString(_rememberMeKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      return RememberMeModel(
        email: json['email'] as String,
        encryptedPassword: json['encryptedPassword'] as String?,
        userId: json['userId'] as String?,
        token: json['token'] as String?,
        enabled: json['enabled'] as bool? ?? true,
        lastLoginAt: json['lastLoginAt'] != null
            ? DateTime.parse(json['lastLoginAt'] as String)
            : null,
        deviceId: json['deviceId'] as String?,
      );
    } catch (e) {
      return null;
    }
  }

  /// Gets the stored "Remember Me" data.
  Future<RememberMeModel?> getRememberMe() async {
    return getCredentials();
  }

  /// Clears stored "Remember Me" data.
  Future<void> clearCredentials() async {
    await _prefs.remove(_rememberMeKey);
    await _prefs.remove(_rememberMeEnabledKey);
  }

  /// Checks if "Remember Me" is enabled.
  Future<bool> isEnabled() async {
    return _prefs.getBool(_rememberMeEnabledKey) ?? false;
  }

  /// Disables "Remember Me" without clearing data.
  Future<void> disable() async {
    await _prefs.setBool(_rememberMeEnabledKey, false);
  }

  /// Enables "Remember Me".
  Future<void> enable() async {
    await _prefs.setBool(_rememberMeEnabledKey, true);
  }

  /// Updates last login time.
  Future<void> updateLastLogin() async {
    final credentials = await getCredentials();
    if (credentials == null) return;

    final updated = credentials.copyWith(
      lastLoginAt: DateTime.now(),
    );

    final json = jsonEncode({
      'email': updated.email,
      'encryptedPassword': updated.encryptedPassword,
      'userId': updated.userId,
      'token': updated.token,
      'deviceId': updated.deviceId,
      'enabled': updated.enabled,
      'lastLoginAt': updated.lastLoginAt?.toIso8601String(),
    });

    await _prefs.setString(_rememberMeKey, json);
  }

  //--------------------------------------------------------------------------
  // Private Helpers
  //--------------------------------------------------------------------------

  /// Encrypts a password for storage.
  String _encryptPassword(String password) {
    // Using SHA-256 for encryption (not reversible)
    // This is a simple hash - in production, use a proper encryption method
    final bytes = convert.utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Decrypts an encrypted password.
  /// Note: SHA-256 is one-way, so we can't truly decrypt.
  /// This is only for comparing stored hash with input.
  String _decryptPassword(String encrypted) {
    // Since we're using SHA-256 (one-way), we can't decrypt
    // We compare hashes instead of decrypting
    return encrypted;
  }

  /// Verifies a password against stored encrypted password.
  bool verifyPassword(String input, String storedEncrypted) {
    final inputHash = _encryptPassword(input);
    return inputHash == storedEncrypted;
  }
}
