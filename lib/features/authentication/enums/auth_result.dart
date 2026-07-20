/// Result of authentication operations.
///
/// Represents the outcome of authentication-related operations
/// to provide clear feedback to the UI layer.
enum AuthResult {
  /// Operation completed successfully
  success,

  /// User cancelled the operation
  cancelled,

  /// Invalid credentials provided
  invalidCredentials,

  /// Email already registered
  emailAlreadyInUse,

  /// User not found
  userNotFound,

  /// Wrong password
  wrongPassword,

  /// Too many attempts, rate limited
  tooManyRequests,

  /// Network error occurred
  networkError,

  /// Operation timed out
  timeout,

  /// Account is blocked
  accountBlocked,

  /// Account is disabled
  accountDisabled,

  /// Email not verified
  emailNotVerified,

  /// Invalid OTP
  invalidOtp,

  /// OTP expired
  otpExpired,

  /// Session expired
  sessionExpired,

  /// Biometric not supported
  biometricNotSupported,

  /// Biometric failed
  biometricFailed,

  /// Biometric locked
  biometricLocked,

  /// Unknown error occurred
  unknown,
}

/// Extension methods for [AuthResult].
extension AuthResultExtension on AuthResult {
  /// Returns true if the result indicates success.
  bool get isSuccess => this == AuthResult.success;

  /// Returns true if the result indicates a user error.
  bool get isUserError {
    switch (this) {
      case AuthResult.invalidCredentials:
      case AuthResult.emailAlreadyInUse:
      case AuthResult.userNotFound:
      case AuthResult.wrongPassword:
      case AuthResult.invalidOtp:
      case AuthResult.otpExpired:
        return true;
      default:
        return false;
    }
  }

  /// Returns true if the result indicates a system error.
  bool get isSystemError {
    switch (this) {
      case AuthResult.networkError:
      case AuthResult.timeout:
      case AuthResult.unknown:
        return true;
      default:
        return false;
    }
  }

  /// Returns true if the result indicates the user should retry.
  bool get shouldRetry {
    switch (this) {
      case AuthResult.networkError:
      case AuthResult.timeout:
      case AuthResult.tooManyRequests:
        return true;
      default:
        return false;
    }
  }

  /// Returns true if the result is a lockout condition.
  bool get isLockout {
    switch (this) {
      case AuthResult.accountBlocked:
      case AuthResult.accountDisabled:
      case AuthResult.biometricLocked:
        return true;
      default:
        return false;
    }
  }
}
