import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/auth_routes.dart';
import '../enums/auth_status.dart';
import '../enums/verification_status.dart';

/// Helper for handling authentication redirects.
class AuthRedirectHelper {
  AuthRedirectHelper._();

  /// Redirects based on authentication status.
  static String getInitialRoute(AuthStatus status) {
    switch (status) {
      case AuthStatus.authenticated:
        return '/dashboard';
      case AuthStatus.unverified:
        return AuthRoutes.verifyEmail;
      case AuthStatus.blocked:
        return AuthRoutes.accountBlocked;
      case AuthStatus.sessionExpired:
        return AuthRoutes.login;
      case AuthStatus.initial:
      case AuthStatus.unauthenticated:
      case AuthStatus.failed:
      default:
        return AuthRoutes.splash;
    }
  }

  /// Navigates to the appropriate page based on auth status.
  static Future<void> navigateBasedOnStatus(
    BuildContext context,
    AuthStatus status, {
    Map<String, String>? extraParams,
  }) async {
    final route = getInitialRoute(status);
    context.go(route, extra: extraParams);
  }

  /// Redirects to login with a redirect parameter.
  static void redirectToLogin(
    BuildContext context, {
    String? redirectAfterLogin,
  }) {
    if (redirectAfterLogin != null) {
      context.go(
        '${AuthRoutes.login}?${AuthRoutes.redirectParam}=$redirectAfterLogin',
      );
    } else {
      context.go(AuthRoutes.login);
    }
  }

  /// Redirects to the dashboard.
  static void goToDashboard(BuildContext context) {
    context.go('/dashboard');
  }

  /// Redirects to the home page.
  static void goToHome(BuildContext context) {
    context.go('/');
  }

  /// Redirects back or to a fallback route.
  static void goBackOrToHome(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      goToHome(context);
    }
  }

  /// Navigates to email verification with email parameter.
  static void goToEmailVerification(
    BuildContext context, {
    required String email,
  }) {
    context.go(
      '${AuthRoutes.verifyEmail}?${AuthRoutes.emailParam}=$email',
    );
  }

  /// Navigates to OTP verification with parameters.
  static void goToOtpVerification(
    BuildContext context, {
    required String email,
    required String otpType,
  }) {
    context.go(
      '${AuthRoutes.otp}?${AuthRoutes.emailParam}=$email&${AuthRoutes.otpTypeParam}=$otpType',
    );
  }

  /// Navigates to reset password with token.
  static void goToResetPassword(
    BuildContext context, {
    required String email,
    required String token,
  }) {
    context.go(
      '${AuthRoutes.resetPassword}?${AuthRoutes.emailParam}=$email&${AuthRoutes.tokenParam}=$token',
    );
  }

  /// Handles redirect after successful login.
  static void handleLoginSuccess(
    BuildContext context, {
    String? redirectPath,
  }) {
    if (redirectPath != null && redirectPath.isNotEmpty) {
      context.go(redirectPath);
    } else {
      goToDashboard(context);
    }
  }

  /// Handles redirect after logout.
  static void handleLogout(BuildContext context) {
    context.go(AuthRoutes.login);
  }

  /// Handles redirect after account deletion.
  static void handleAccountDeletion(BuildContext context) {
    context.go(AuthRoutes.login);
  }

  /// Pushes a route and removes all previous routes.
  static void pushReplacementNamed(
    BuildContext context,
    String route, {
    Object? extra,
  }) {
    context.go(route, extra: extra);
  }
}
