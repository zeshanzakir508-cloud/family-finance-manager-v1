/// Authentication route names for navigation.
///
/// Contains all route names used in the authentication feature.
/// These are used with [AppRouter] for navigation.
class AuthRoutes {
  AuthRoutes._();

  //--------------------------------------------------------------------------
  // Auth Flow Routes
  //--------------------------------------------------------------------------

  /// Splash screen route
  static const String splash = '/splash';

  /// Onboarding screen route
  static const String onboarding = '/onboarding';

  /// Welcome screen route
  static const String welcome = '/welcome';

  /// Login screen route
  static const String login = '/login';

  /// Register screen route
  static const String register = '/register';

  /// Forgot password screen route
  static const String forgotPassword = '/forgot-password';

  /// Reset password screen route
  static const String resetPassword = '/reset-password';

  /// Verify email screen route
  static const String verifyEmail = '/verify-email';

  /// OTP verification screen route
  static const String otp = '/otp';

  /// Account blocked screen route
  static const String accountBlocked = '/account-blocked';

  //--------------------------------------------------------------------------
  // Route Parameters
  //--------------------------------------------------------------------------

  /// Parameter for redirect URL after auth
  static const String redirectParam = 'redirect';

  /// Parameter for email in reset password flow
  static const String emailParam = 'email';

  /// Parameter for OTP type
  static const String otpTypeParam = 'otpType';

  /// Parameter for user ID
  static const String userIdParam = 'userId';

  /// Parameter for token
  static const String tokenParam = 'token';
}
