/// Authentication-specific constants for the app.
///
/// Contains auth-specific configuration values that are not part of
/// the global [AppConstants] to maintain separation of concerns.
class AuthConstants {
  AuthConstants._();

  //--------------------------------------------------------------------------
  // Session
  //--------------------------------------------------------------------------

  /// Default session timeout duration (30 days)
  static const Duration sessionTimeout = Duration(days: 30);

  /// Auto-logout duration for inactive sessions (15 minutes)
  static const Duration autoLogoutDuration = Duration(minutes: 15);

  /// Session refresh interval (5 minutes)
  static const Duration sessionRefreshInterval = Duration(minutes: 5);

  //--------------------------------------------------------------------------
  // OTP
  //--------------------------------------------------------------------------

  /// OTP code length
  static const int otpLength = 6;

  /// OTP expiration duration (5 minutes)
  static const Duration otpExpirationDuration = Duration(minutes: 5);

  /// OTP resend cooldown (30 seconds)
  static const Duration otpResendCooldown = Duration(seconds: 30);

  //--------------------------------------------------------------------------
  // Password Reset
  //--------------------------------------------------------------------------

  /// Password reset token expiration (1 hour)
  static const Duration passwordResetExpiration = Duration(hours: 1);

  //--------------------------------------------------------------------------
  // Email Verification
  //--------------------------------------------------------------------------

  /// Email verification token expiration (24 hours)
  static const Duration emailVerificationExpiration = Duration(hours: 24);

  /// Maximum email verification resend attempts
  static const int maxEmailVerificationResends = 3;

  //--------------------------------------------------------------------------
  // Biometric
  //--------------------------------------------------------------------------

  /// Maximum biometric authentication attempts
  static const int maxBiometricAttempts = 3;

  /// Biometric lockout duration (15 minutes)
  static const Duration biometricLockoutDuration = Duration(minutes: 15);

  //--------------------------------------------------------------------------
  // Rate Limiting
  //--------------------------------------------------------------------------

  /// Maximum login attempts before lockout
  static const int maxLoginAttempts = 5;

  /// Account lockout duration (30 minutes)
  static const Duration accountLockoutDuration = Duration(minutes: 30);

  /// Maximum OTP verification attempts
  static const int maxOtpAttempts = 3;

  //--------------------------------------------------------------------------
  // Tokens
  //--------------------------------------------------------------------------

  /// Access token expiration (15 minutes)
  static const Duration accessTokenExpiration = Duration(minutes: 15);

  /// Refresh token expiration (7 days)
  static const Duration refreshTokenExpiration = Duration(days: 7);

  //--------------------------------------------------------------------------
  // Remember Me
  //--------------------------------------------------------------------------

  /// Remember me token expiration (30 days)
  static const Duration rememberMeExpiration = Duration(days: 30);

  //--------------------------------------------------------------------------
  // Debounce
  //--------------------------------------------------------------------------

  /// Auth form submission debounce (500ms)
  static const Duration authDebounceDuration = Duration(milliseconds: 500);
}
