/// Authentication-specific messages used across the auth feature.
///
/// Contains user-facing messages for login, registration, password reset,
/// and other auth operations. These are separate from [AppStrings] to
/// keep auth messages organized and maintainable.
class AuthMessages {
  AuthMessages._();

  //--------------------------------------------------------------------------
  // Success Messages
  //--------------------------------------------------------------------------

  static const String loginSuccess = 'Welcome back! You have been logged in successfully.';
  static const String registerSuccess = 'Account created successfully! Please verify your email.';
  static const String logoutSuccess = 'You have been logged out successfully.';
  static const String passwordResetSent = 'Password reset link has been sent to your email.';
  static const String passwordResetSuccess = 'Your password has been reset successfully.';
  static const String emailVerificationSent = 'Verification email has been sent. Please check your inbox.';
  static const String emailVerificationSuccess = 'Your email has been verified successfully!';
  static const String otpSent = 'OTP has been sent to your registered email/phone.';
  static const String otpVerified = 'OTP verified successfully!';
  static const String accountDeleted = 'Your account has been deleted successfully.';
  static const String profileUpdated = 'Profile updated successfully.';
  static const String sessionRefreshed = 'Session refreshed successfully.';

  //--------------------------------------------------------------------------
  // Error Messages
  //--------------------------------------------------------------------------

  static const String loginFailed = 'Login failed. Please check your credentials and try again.';
  static const String registerFailed = 'Registration failed. Please try again.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String invalidPassword = 'Password must be at least 8 characters long.';
  static const String passwordsDoNotMatch = 'Passwords do not match. Please try again.';
  static const String emailAlreadyInUse = 'This email is already registered. Please login or use a different email.';
  static const String userNotFound = 'No account found with this email. Please register first.';
  static const String wrongPassword = 'Incorrect password. Please try again.';
  static const String tooManyRequests = 'Too many attempts. Please try again later.';
  static const String networkError = 'Network error. Please check your internet connection.';
  static const String sessionExpired = 'Your session has expired. Please login again.';
  static const String accountBlocked = 'Your account has been blocked. Please contact support.';
  static const String accountDisabled = 'Your account has been disabled. Please contact support.';
  static const String invalidOtp = 'Invalid OTP. Please check and try again.';
  static const String otpExpired = 'OTP has expired. Please request a new one.';
  static const String otpTooManyAttempts = 'Too many OTP attempts. Please wait before trying again.';
  static const String passwordResetFailed = 'Password reset failed. Please try again.';
  static const String emailVerificationFailed = 'Email verification failed. Please try again.';
  static const String deleteAccountFailed = 'Failed to delete account. Please try again.';
  static const String biometricNotSupported = 'Biometric authentication is not supported on this device.';
  static const String biometricFailed = 'Biometric authentication failed. Please try again.';
  static const String biometricLocked = 'Biometric authentication is locked. Please use password.';

  //--------------------------------------------------------------------------
  // Info Messages
  //--------------------------------------------------------------------------

  static const String checkEmail = 'Please check your email for verification link.';
  static const String checkSpam = 'If you don\'t see the email, please check your spam folder.';
  static const String resendEmail = 'Resend verification email?';
  static const String resendOtp = 'Resend OTP?';
  static const String waitingForVerification = 'Please verify your email to continue.';
  static const String sessionWillExpire = 'Your session will expire soon. Please stay active.';
  static const String loggingOut = 'Logging out...';
  static const String deletingAccount = 'Deleting account...';
  static const String processing = 'Processing...';
  static const String pleaseWait = 'Please wait...';

  //--------------------------------------------------------------------------
  // Confirmation Dialog Messages
  //--------------------------------------------------------------------------

  static const String confirmLogout = 'Are you sure you want to logout?';
  static const String confirmDeleteAccount = 'Are you sure you want to delete your account? This action cannot be undone.';
  static const String confirmResendEmail = 'A new verification email will be sent to your registered email address.';
  static const String sessionExpiredDialog = 'Your session has expired. Please login again to continue.';

  //--------------------------------------------------------------------------
  // Input Hints
  //--------------------------------------------------------------------------

  static const String emailHint = 'Enter your email address';
  static const String passwordHint = 'Enter your password';
  static const String confirmPasswordHint = 'Confirm your password';
  static const String usernameHint = 'Choose a username';
  static const String phoneHint = 'Enter your phone number';
  static const String otpHint = 'Enter the 6-digit code';
  static const String currentPasswordHint = 'Enter your current password';
  static const String newPasswordHint = 'Enter your new password';

  //--------------------------------------------------------------------------
  // Validation Messages
  //--------------------------------------------------------------------------

  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String usernameRequired = 'Username is required';
  static const String phoneRequired = 'Phone number is required';
  static const String otpRequired = 'OTP is required';
  static const String termsRequired = 'You must accept the terms and conditions';
  static const String passwordMinLength = 'Password must be at least 8 characters';
  static const String passwordMaxLength = 'Password must be less than 128 characters';
  static const String passwordUppercase = 'Password must contain at least one uppercase letter';
  static const String passwordLowercase = 'Password must contain at least one lowercase letter';
  static const String passwordNumber = 'Password must contain at least one number';
  static const String passwordSpecial = 'Password must contain at least one special character';
}
