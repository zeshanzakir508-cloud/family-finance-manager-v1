import '../enums/auth_result.dart';
import '../constants/auth_messages.dart';

/// Helper for mapping authentication errors to user-friendly messages.
class AuthErrorMapper {
  AuthErrorMapper._();

  /// Maps an [AuthResult] to a user-friendly error message.
  static String mapToMessage(AuthResult result) {
    switch (result) {
      case AuthResult.success:
        return AuthMessages.loginSuccess;

      case AuthResult.cancelled:
        return 'Operation was cancelled.';

      case AuthResult.invalidCredentials:
        return AuthMessages.invalidEmail;

      case AuthResult.emailAlreadyInUse:
        return AuthMessages.emailAlreadyInUse;

      case AuthResult.userNotFound:
        return AuthMessages.userNotFound;

      case AuthResult.wrongPassword:
        return AuthMessages.wrongPassword;

      case AuthResult.tooManyRequests:
        return AuthMessages.tooManyRequests;

      case AuthResult.networkError:
        return AuthMessages.networkError;

      case AuthResult.timeout:
        return 'Request timed out. Please try again.';

      case AuthResult.accountBlocked:
        return AuthMessages.accountBlocked;

      case AuthResult.accountDisabled:
        return AuthMessages.accountDisabled;

      case AuthResult.emailNotVerified:
        return AuthMessages.waitingForVerification;

      case AuthResult.invalidOtp:
        return AuthMessages.invalidOtp;

      case AuthResult.otpExpired:
        return AuthMessages.otpExpired;

      case AuthResult.sessionExpired:
        return AuthMessages.sessionExpired;

      case AuthResult.biometricNotSupported:
        return AuthMessages.biometricNotSupported;

      case AuthResult.biometricFailed:
        return AuthMessages.biometricFailed;

      case AuthResult.biometricLocked:
        return AuthMessages.biometricLocked;

      case AuthResult.unknown:
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Returns true if the error is retryable.
  static bool isRetryable(AuthResult result) {
    switch (result) {
      case AuthResult.networkError:
      case AuthResult.timeout:
      case AuthResult.tooManyRequests:
        return true;
      default:
        return false;
    }
  }

  /// Returns true if the error requires user action.
  static bool requiresUserAction(AuthResult result) {
    switch (result) {
      case AuthResult.invalidCredentials:
      case AuthResult.wrongPassword:
      case AuthResult.invalidOtp:
      case AuthResult.otpExpired:
        return true;
      default:
        return false;
    }
  }

  /// Returns true if the error is a lockout condition.
  static bool isLockout(AuthResult result) {
    switch (result) {
      case AuthResult.accountBlocked:
      case AuthResult.accountDisabled:
      case AuthResult.biometricLocked:
        return true;
      default:
        return false;
    }
  }

  /// Returns an appropriate action suggestion for the error.
  static String getActionSuggestion(AuthResult result) {
    switch (result) {
      case AuthResult.emailNotVerified:
        return 'Please check your email and verify your account.';
      case AuthResult.invalidOtp:
        return 'Please enter a valid 6-digit OTP code.';
      case AuthResult.otpExpired:
        return 'Please request a new OTP code.';
      case AuthResult.accountBlocked:
        return 'Please contact support for assistance.';
      case AuthResult.sessionExpired:
        return 'Please login again to continue.';
      default:
        return 'Please try again.';
    }
  }
}
