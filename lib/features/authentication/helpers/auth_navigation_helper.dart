import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/auth_routes.dart';
import '../enums/auth_status.dart';

/// Helper for authentication-related navigation.
class AuthNavigationHelper {
  AuthNavigationHelper._();

  /// Navigates to the splash screen.
  static void goToSplash(BuildContext context) {
    context.go(AuthRoutes.splash);
  }

  /// Navigates to the onboarding screen.
  static void goToOnboarding(BuildContext context) {
    context.go(AuthRoutes.onboarding);
  }

  /// Navigates to the welcome screen.
  static void goToWelcome(BuildContext context) {
    context.go(AuthRoutes.welcome);
  }

  /// Navigates to the login screen.
  static void goToLogin(BuildContext context, {String? redirect}) {
    if (redirect != null) {
      context.go('${AuthRoutes.login}?${AuthRoutes.redirectParam}=$redirect');
    } else {
      context.go(AuthRoutes.login);
    }
  }

  /// Navigates to the register screen.
  static void goToRegister(BuildContext context) {
    context.go(AuthRoutes.register);
  }

  /// Navigates to the forgot password screen.
  static void goToForgotPassword(BuildContext context) {
    context.go(AuthRoutes.forgotPassword);
  }

  /// Navigates to the reset password screen.
  static void goToResetPassword(BuildContext context, {
    required String email,
    required String token,
  }) {
    context.go(
      '${AuthRoutes.resetPassword}?${AuthRoutes.emailParam}=$email&${AuthRoutes.tokenParam}=$token',
    );
  }

  /// Navigates to the verify email screen.
  static void goToVerifyEmail(BuildContext context, {required String email}) {
    context.go(
      '${AuthRoutes.verifyEmail}?${AuthRoutes.emailParam}=$email',
    );
  }

  /// Navigates to the OTP screen.
  static void goToOtp(BuildContext context, {
    required String email,
    required String otpType,
  }) {
    context.go(
      '${AuthRoutes.otp}?${AuthRoutes.emailParam}=$email&${AuthRoutes.otpTypeParam}=$otpType',
    );
  }

  /// Navigates to the account blocked screen.
  static void goToAccountBlocked(BuildContext context) {
    context.go(AuthRoutes.accountBlocked);
  }

  /// Navigates to the dashboard.
  static void goToDashboard(BuildContext context) {
    context.go('/dashboard');
  }

  /// Navigates to the home screen.
  static void goToHome(BuildContext context) {
    context.go('/');
  }

  /// Pushes a named route.
  static Future<T?> pushNamed<T>(
    BuildContext context,
    String route, {
    Object? extra,
  }) {
    return context.pushNamed(route, extra: extra);
  }

  /// Pushes a route and removes the current route.
  static Future<T?> pushReplacementNamed<T>(
    BuildContext context,
    String route, {
    Object? extra,
  }) {
    return context.pushReplacementNamed(route, extra: extra);
  }

  /// Pushes a route and removes all previous routes.
  static Future<T?> pushNamedAndRemoveUntil<T>(
    BuildContext context,
    String route, {
    Object? extra,
  }) {
    context.go(route, extra: extra);
    return Future.value(null);
  }

  /// Pops the current route.
  static void pop<T>(BuildContext context, [T? result]) {
    if (context.canPop()) {
      context.pop(result);
    }
  }

  /// Pops until the specified route.
  static void popUntil(BuildContext context, String route) {
    context.go(route);
  }

  /// Checks if the current route is a specific route.
  static bool isCurrentRoute(BuildContext context, String route) {
    final location = GoRouterState.of(context).uri.path;
    return location == route;
  }

  /// Gets the current route path.
  static String getCurrentRoute(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  /// Gets a parameter from the current route.
  static String? getRouteParameter(BuildContext context, String param) {
    return GoRouterState.of(context).uri.queryParameters[param];
  }

  /// Navigates based on authentication status.
  static void navigateByAuthStatus(
    BuildContext context,
    AuthStatus status, {
    String? redirect,
  }) {
    switch (status) {
      case AuthStatus.authenticated:
        goToDashboard(context);
        break;
      case AuthStatus.unverified:
        // Get email from current user or use default
        // This should be handled by the calling code
        break;
      case AuthStatus.blocked:
        goToAccountBlocked(context);
        break;
      case AuthStatus.sessionExpired:
        goToLogin(context, redirect: redirect);
        break;
      case AuthStatus.initial:
      case AuthStatus.unauthenticated:
      case AuthStatus.failed:
      default:
        goToSplash(context);
        break;
    }
  }

  /// Shows a snackbar with a message.
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }

  /// Shows a loading dialog.
  static Future<void> showLoadingDialog(
    BuildContext context, {
    String message = 'Please wait...',
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  /// Dismisses the current dialog.
  static void dismissDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
