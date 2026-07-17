import 'package:flutter/material.dart';

import 'app_routes.dart';

/// ============================================================================
/// Family Finance Manager
/// App Router
/// ----------------------------------------------------------------------------
/// Centralized route generator.
///
/// NOTE:
/// Screen routes will be added module by module as they are implemented.
/// ============================================================================

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //======================================================================
      // Splash
      //======================================================================

      case AppRoutes.splash:
        // TODO:
        // Return SplashScreen when implemented.
        break;

      //======================================================================
      // Authentication
      //======================================================================

      // case AppRoutes.login:
      // case AppRoutes.register:

      //======================================================================
      // Dashboard
      //======================================================================

      // case AppRoutes.dashboard:

      //======================================================================
      // Accounts
      //======================================================================

      //======================================================================
      // Transactions
      //======================================================================

      //======================================================================
      // Categories
      //======================================================================

      //======================================================================
      // Reports
      //======================================================================

      //======================================================================
      // Settings
      //======================================================================
    }

    return MaterialPageRoute(
      builder: (_) => const _RouteNotFoundScreen(),
      settings: settings,
    );
  }
}

/// ============================================================================
/// Route Not Found
/// ============================================================================

class _RouteNotFoundScreen extends StatelessWidget {
  const _RouteNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Not Found'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No route defined for:\n$routeName',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
