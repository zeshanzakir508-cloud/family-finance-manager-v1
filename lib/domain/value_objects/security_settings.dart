// lib/domain/value_objects/security_settings.dart

import 'package:equatable/equatable.dart';

/// Value object representing user security settings.
class SecuritySettings extends Equatable {
  /// Whether biometric authentication is enabled.
  final bool biometricEnabled;

  /// Whether PIN authentication is enabled.
  final bool pinEnabled;

  /// Whether two-factor authentication is enabled.
  final bool twoFactorEnabled;

  /// Session timeout in minutes.
  final int sessionTimeout;

  /// Whether login history is tracked.
  final bool trackLoginHistory;

  const SecuritySettings({
    this.biometricEnabled = false,
    this.pinEnabled = false,
    this.twoFactorEnabled = false,
    this.sessionTimeout = 30,
    this.trackLoginHistory = true,
  })  : assert(sessionTimeout > 0, 'Session timeout must be greater than 0'),
        assert(sessionTimeout <= 1440, 'Session timeout cannot exceed 1440 minutes (24 hours)');

  /// Creates a copy of this security settings with the given fields replaced.
  SecuritySettings copyWith({
    bool? biometricEnabled,
    bool? pinEnabled,
    bool? twoFactorEnabled,
    int? sessionTimeout,
    bool? trackLoginHistory,
  }) {
    return SecuritySettings(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinEnabled: pinEnabled ?? this.pinEnabled,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      sessionTimeout: sessionTimeout ?? this.sessionTimeout,
      trackLoginHistory: trackLoginHistory ?? this.trackLoginHistory,
    );
  }

  /// Returns whether any security feature is enabled.
  bool get hasSecurityEnabled =>
      biometricEnabled || pinEnabled || twoFactorEnabled;

  /// Returns whether biometric is enabled.
  bool get isBiometricEnabled => biometricEnabled;

  /// Returns whether PIN is enabled.
  bool get isPinEnabled => pinEnabled;

  /// Returns whether 2FA is enabled.
  bool get isTwoFactorEnabled => twoFactorEnabled;

  @override
  List<Object?> get props => [
        biometricEnabled,
        pinEnabled,
        twoFactorEnabled,
        sessionTimeout,
        trackLoginHistory,
      ];
}
