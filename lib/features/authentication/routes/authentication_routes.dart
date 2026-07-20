import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/auth_routes.dart';
import '../views/pages/splash_page.dart';
import '../views/pages/onboarding_page.dart';
import '../views/pages/welcome_page.dart';
import '../views/pages/login_page.dart';
import '../views/pages/register_page.dart';
import '../views/pages/forgot_password_page.dart';
import '../views/pages/reset_password_page.dart';
import '../views/pages/verify_email_page.dart';
import '../views/pages/otp_page.dart';
import '../views/pages/account_blocked_page.dart';

/// Authentication route configuration.
class AuthenticationRoutes {
  AuthenticationRoutes._();

  /// Returns the authentication route configuration.
  static List<GoRoute> get routes => [
    // Splash Route
    GoRoute(
      path: AuthRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),

    // Onboarding Route
    GoRoute(
      path: AuthRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),

    // Welcome Route
    GoRoute(
      path: AuthRoutes.welcome,
      name: 'welcome',
      builder: (context, state) => const WelcomePage(),
    ),

    // Login Route
    GoRoute(
      path: AuthRoutes.login,
      name: 'login',
      builder: (context, state) {
        final redirect = state.uri.queryParameters[AuthRoutes.redirectParam];
        return LoginPage(redirect: redirect);
      },
    ),

    // Register Route
    GoRoute(
      path: AuthRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),

    // Forgot Password Route
    GoRoute(
      path: AuthRoutes.forgotPassword,
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),

    // Reset Password Route
    GoRoute(
      path: AuthRoutes.resetPassword,
      name: 'reset-password',
      builder: (context, state) {
        final email = state.uri.queryParameters[AuthRoutes.emailParam] ?? '';
        final token = state.uri.queryParameters[AuthRoutes.tokenParam] ?? '';
        return ResetPasswordPage(email: email, token: token);
      },
    ),

    // Verify Email Route
    GoRoute(
      path: AuthRoutes.verifyEmail,
      name: 'verify-email',
      builder: (context, state) {
        final email = state.uri.queryParameters[AuthRoutes.emailParam] ?? '';
        return VerifyEmailPage(email: email);
      },
    ),

    // OTP Route
    GoRoute(
      path: AuthRoutes.otp,
      name: 'otp',
      builder: (context, state) {
        final email = state.uri.queryParameters[AuthRoutes.emailParam] ?? '';
        final otpType = state.uri.queryParameters[AuthRoutes.otpTypeParam] ?? '';
        return OtpPage(email: email, otpType: otpType);
      },
    ),

    // Account Blocked Route
    GoRoute(
      path: AuthRoutes.accountBlocked,
      name: 'account-blocked',
      builder: (context, state) => const AccountBlockedPage(),
    ),
  ];

  /// Returns the initial route for the authentication feature.
  static String get initialRoute => AuthRoutes.splash;

  /// Returns the redirect route for authenticated users.
  static String get authenticatedRoute => '/dashboard';

  /// Returns the redirect route for unauthenticated users.
  static String get unauthenticatedRoute => AuthRoutes.login;

  /// Checks if a route is an authentication route.
  static bool isAuthRoute(String path) {
    const authRoutes = [
      AuthRoutes.splash,
      AuthRoutes.onboarding,
      AuthRoutes.welcome,
      AuthRoutes.login,
      AuthRoutes.register,
      AuthRoutes.forgotPassword,
      AuthRoutes.resetPassword,
      AuthRoutes.verifyEmail,
      AuthRoutes.otp,
      AuthRoutes.accountBlocked,
    ];
    return authRoutes.contains(path);
  }

  /// Returns the login route with an optional redirect parameter.
  static String getLoginRoute({String? redirect}) {
    if (redirect != null) {
      return '${AuthRoutes.login}?${AuthRoutes.redirectParam}=$redirect';
    }
    return AuthRoutes.login;
  }

  /// Returns the reset password route with parameters.
  static String getResetPasswordRoute({
    required String email,
    required String token,
  }) {
    return '${AuthRoutes.resetPassword}?${AuthRoutes.emailParam}=$email&${AuthRoutes.tokenParam}=$token';
  }

  /// Returns the verify email route with email parameter.
  static String getVerifyEmailRoute({required String email}) {
    return '${AuthRoutes.verifyEmail}?${AuthRoutes.emailParam}=$email';
  }

  /// Returns the OTP route with parameters.
  static String getOtpRoute({
    required String email,
    required String otpType,
  }) {
    return '${AuthRoutes.otp}?${AuthRoutes.emailParam}=$email&${AuthRoutes.otpTypeParam}=$otpType';
  }
}
