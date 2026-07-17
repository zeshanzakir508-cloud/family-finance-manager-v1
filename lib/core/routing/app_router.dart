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
      //----------------------------------------------------------------------
      // Splash
      //----------------------------------------------------------------------

      case AppRoutes.splash:

      //----------------------------------------------------------------------
      // Unknown Route
      //----------------------------------------------------------------------

      default:
        return MaterialPageRoute(
          builder: (_) => const _RouteNotFoundScreen(),
          settings: settings,
        );
    }
  }
}

/// ============================================================================
/// Route Not Found
/// ============================================================================

class _RouteNotFoundScreen extends StatelessWidget {
  const _RouteNotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Not Found'),
      ),
      body: Center(
        child: Text(
          'No route defined for:\n${ModalRoute.of(context)?.settings.name}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
