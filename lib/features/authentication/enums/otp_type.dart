/// Type of OTP verification.
///
/// Defines the purpose of the OTP being verified.
enum OtpType {
  /// OTP for email verification
  emailVerification,

  /// OTP for phone verification
  phoneVerification,

  /// OTP for password reset
  passwordReset,

  /// OTP for two-factor authentication
  twoFactorAuth,

  /// OTP for login verification
  loginVerification,
}

/// Extension methods for [OtpType].
extension OtpTypeExtension on OtpType {
  /// Returns the display name of the OTP type.
  String get displayName {
    switch (this) {
      case OtpType.emailVerification:
        return 'Email Verification';
      case OtpType.phoneVerification:
        return 'Phone Verification';
      case OtpType.passwordReset:
        return 'Password Reset';
      case OtpType.twoFactorAuth:
        return 'Two-Factor Authentication';
      case OtpType.loginVerification:
        return 'Login Verification';
    }
  }

  /// Returns the expiration duration in seconds for this type.
  int get expirationSeconds {
    switch (this) {
      case OtpType.emailVerification:
        return 300; // 5 minutes
      case OtpType.phoneVerification:
        return 300; // 5 minutes
      case OtpType.passwordReset:
        return 600; // 10 minutes
      case OtpType.twoFactorAuth:
        return 120; // 2 minutes
      case OtpType.loginVerification:
        return 180; // 3 minutes
    }
  }

  /// Returns the OTP length for this type.
  int get otpLength {
    switch (this) {
      case OtpType.emailVerification:
        return 6;
      case OtpType.phoneVerification:
        return 6;
      case OtpType.passwordReset:
        return 8;
      case OtpType.twoFactorAuth:
        return 6;
      case OtpType.loginVerification:
        return 6;
    }
  }

  /// Returns true if this type requires resend capability.
  bool get canResend {
    switch (this) {
      case OtpType.emailVerification:
      case OtpType.phoneVerification:
        return true;
      case OtpType.passwordReset:
      case OtpType.twoFactorAuth:
      case OtpType.loginVerification:
        return false;
    }
  }
}
