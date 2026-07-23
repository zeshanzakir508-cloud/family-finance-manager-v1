import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/onboarding_step.dart';
import '../enums/onboarding_status.dart';
import '../models/onboarding_progress_model.dart';
import '../views/pages/onboarding_page.dart';
import '../views/pages/splash_redirect_page.dart';
import '../helpers/onboarding_navigation_helper.dart';
import '../providers/onboarding_provider.dart';

/// Route names for onboarding
class OnboardingRoutes {
  static const String splash = '/splash';
  static const String home = '/onboarding';
  static const String welcome = '/onboarding/welcome';
  static const String permissions = '/onboarding/permissions';
  static const String terms = '/onboarding/terms';
  static const String family = '/onboarding/family';
  static const String accounts = '/onboarding/accounts';
  static const String categories = '/onboarding/categories';
  static const String finish = '/onboarding/finish';
  static const String dashboard = '/dashboard';

  /// Get the route for a specific step
  static String getRouteForStep(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.welcome:
        return welcome;
      case OnboardingStep.permissions:
        return permissions;
      case OnboardingStep.terms:
        return terms;
      case OnboardingStep.family:
        return family;
      case OnboardingStep.accounts:
        return accounts;
      case OnboardingStep.categories:
        return categories;
      case OnboardingStep.finish:
        return finish;
    }
  }

  /// Get the step from a route
  static OnboardingStep? getStepFromRoute(String route) {
    switch (route) {
      case welcome:
        return OnboardingStep.welcome;
      case permissions:
        return OnboardingStep.permissions;
      case terms:
        return OnboardingStep.terms;
      case family:
        return OnboardingStep.family;
      case accounts:
        return OnboardingStep.accounts;
      case categories:
        return OnboardingStep.categories;
      case finish:
        return OnboardingStep.finish;
      default:
        return null;
    }
  }

  /// Check if a route is an onboarding route
  static bool isOnboardingRoute(String route) {
    return route.startsWith('/onboarding');
  }

  /// Get all onboarding routes
  static List<String> getAllRoutes() {
    return [
      home,
      welcome,
      permissions,
      terms,
      family,
      accounts,
      categories,
      finish,
    ];
  }

  /// Get the initial route based on first launch and completion
  static String getInitialRoute(bool isFirstLaunch, bool isCompleted) {
    if (isFirstLaunch && !isCompleted) {
      return splash;
    }
    return dashboard;
  }

  /// Get the redirect route based on onboarding progress
  static String getRedirectRoute(OnboardingProgressModel progress) {
    if (progress.status == OnboardingStatus.completed ||
        progress.status == OnboardingStatus.skipped) {
      return dashboard;
    }
    return getRouteForStep(progress.currentStep);
  }
}

/// Route configuration for onboarding
class OnboardingRouteConfig {
  /// Get the route settings for a step
  static RouteSettings getRouteSettings(OnboardingStep step) {
    return RouteSettings(
      name: OnboardingRoutes.getRouteForStep(step),
      arguments: {
        'step': step.name,
        'stepIndex': step.index,
        'stepTitle': step.displayName,
      },
    );
  }

  /// Build a route for onboarding
  static Widget buildOnboardingRoute(
    BuildContext context,
    RouteSettings settings,
  ) {
    final routeName = settings.name;
    final step = OnboardingRoutes.getStepFromRoute(routeName ?? '');

    if (step != null) {
      return OnboardingPage(initialStep: step);
    }

    // Default to welcome page
    return OnboardingPage(initialStep: OnboardingStep.welcome);
  }

  /// Build the splash redirect route
  static Widget buildSplashRoute(BuildContext context) {
    return const SplashRedirectPage();
  }

  /// Get the page route for a step with animation
  static PageRoute getPageRoute(
    OnboardingStep step, {
    OnboardingStep? fromStep,
    bool animate = true,
  }) {
    final page = OnboardingPage(initialStep: step);
    final routeName = OnboardingRoutes.getRouteForStep(step);

    if (!animate) {
      return MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(name: routeName),
      );
    }

    // Use custom animation based on direction
    if (fromStep != null) {
      return OnboardingNavigationHelper.getPageRouteBuilder(
        page,
        fromStep,
        step,
      )!;
    }

    // Default fade animation
    return OnboardingNavigationHelper.getFadeRoute(page);
  }

  /// Get the splash page route
  static PageRoute getSplashRoute() {
    return MaterialPageRoute(
      builder: (context) => const SplashRedirectPage(),
      settings: const RouteSettings(name: OnboardingRoutes.splash),
    );
  }

  /// Build the route table for GoRouter
  static Map<String, WidgetBuilder> get routeTable {
    return {
      OnboardingRoutes.splash: (context) => const SplashRedirectPage(),
      OnboardingRoutes.home: (context) => OnboardingPage(),
      OnboardingRoutes.welcome: (context) =>
          OnboardingPage(initialStep: OnboardingStep.welcome),
      OnboardingRoutes.permissions: (context) =>
          OnboardingPage(initialStep: OnboardingStep.permissions),
      OnboardingRoutes.terms: (context) =>
          OnboardingPage(initialStep: OnboardingStep.terms),
      OnboardingRoutes.family: (context) =>
          OnboardingPage(initialStep: OnboardingStep.family),
      OnboardingRoutes.accounts: (context) =>
          OnboardingPage(initialStep: OnboardingStep.accounts),
      OnboardingRoutes.categories: (context) =>
          OnboardingPage(initialStep: OnboardingStep.categories),
      OnboardingRoutes.finish: (context) =>
          OnboardingPage(initialStep: OnboardingStep.finish),
    };
  }

  /// Generate route paths for GoRouter
  static List<String> get routePaths {
    return [
      OnboardingRoutes.splash,
      OnboardingRoutes.home,
      OnboardingRoutes.welcome,
      OnboardingRoutes.permissions,
      OnboardingRoutes.terms,
      OnboardingRoutes.family,
      OnboardingRoutes.accounts,
      OnboardingRoutes.categories,
      OnboardingRoutes.finish,
    ];
  }

  /// Check if a route requires onboarding completion
  static bool requiresOnboarding(String route) {
    // All onboarding routes don't require completion
    if (isOnboardingRoute(route)) return false;
    
    // Protected routes that require onboarding
    final protectedRoutes = [
      '/dashboard',
      '/budgets',
      '/transactions',
      '/reports',
      '/settings',
    ];
    
    return protectedRoutes.any((protected) => route.startsWith(protected));
  }

  /// Get the route to redirect to if onboarding is required
  static String getOnboardingRequiredRoute() {
    return OnboardingRoutes.home;
  }
}

/// Extension for GoRouter navigation context
extension OnboardingRouteContext on BuildContext {
  /// Navigate to an onboarding step
  void goToOnboardingStep(OnboardingStep step) {
    final route = OnboardingRoutes.getRouteForStep(step);
    // Use GoRouter if available, otherwise use Navigator
    try {
      // Try to use GoRouter
      final router = Router.of(this);
      if (router != null) {
        // Use GoRouter navigation
        Navigator.pushReplacementNamed(this, route);
      } else {
        Navigator.pushReplacementNamed(this, route);
      }
    } catch (e) {
      // Fallback to standard navigation
      Navigator.pushReplacementNamed(this, route);
    }
  }

  /// Navigate to the onboarding home
  void goToOnboardingHome() {
    Navigator.pushReplacementNamed(this, OnboardingRoutes.home);
  }

  /// Navigate to the dashboard
  void goToDashboard() {
    Navigator.pushReplacementNamed(this, OnboardingRoutes.dashboard);
  }

  /// Navigate to the splash screen
  void goToSplash() {
    Navigator.pushReplacementNamed(this, OnboardingRoutes.splash);
  }

  /// Navigate to the next onboarding step
  void goToNextOnboardingStep(OnboardingStep currentStep) {
    final next = currentStep.next;
    if (next != null) {
      goToOnboardingStep(next);
    }
  }

  /// Navigate to the previous onboarding step
  void goToPreviousOnboardingStep(OnboardingStep currentStep) {
    final previous = currentStep.previous;
    if (previous != null) {
      goToOnboardingStep(previous);
    }
  }
}

/// Extension for GoRouter redirect logic
extension OnboardingRedirectLogic on BuildContext {
  /// Check if the current route is protected and needs onboarding
  bool needsOnboardingRedirect(String route) {
    final isProtected = OnboardingRouteConfig.requiresOnboarding(route);
    if (!isProtected) return false;
    
    // Check if onboarding is complete
    final isComplete = ref.read(isOnboardingCompleteProvider);
    return !isComplete;
  }

  /// Get the redirect destination for protected routes
  String getOnboardingRedirectDestination() {
    return OnboardingRouteConfig.getOnboardingRequiredRoute();
  }
}

/// Provider for onboarding routes
final onboardingRouteProvider = Provider<OnboardingRouteConfig>((ref) {
  return OnboardingRouteConfig();
});

/// Provider for the current onboarding route
final currentOnboardingRouteProvider = Provider<String?>((ref) {
  // This would be used with a router to get the current route
  return null;
});

/// Provider for checking if onboarding is accessible
final isOnboardingAccessibleProvider = Provider<bool>((ref) {
  final state = ref.watch(onboardingStateProvider);
  // Onboarding is accessible if not completed and not skipped
  return !state.isCompleted && !state.isSkipped;
});

/// Provider for onboarding redirect destination
final onboardingRedirectDestinationProvider = Provider<String>((ref) {
  final state = ref.watch(onboardingStateProvider);
  if (state.isCompleted || state.isSkipped) {
    return OnboardingRoutes.dashboard;
  }
  return OnboardingRoutes.getRouteForStep(state.currentStep);
});

/// Provider for all onboarding routes
final allOnboardingRoutesProvider = Provider<List<String>>((ref) {
  return OnboardingRoutes.getAllRoutes();
});

/// Provider for onboarding route parameters
final onboardingRouteParamsProvider = Provider.family<Map<String, dynamic>, String>((ref, route) {
  final step = OnboardingRoutes.getStepFromRoute(route);
  if (step != null) {
    return {
      'step': step.name,
      'stepIndex': step.index,
      'stepTitle': step.displayName,
      'isRequired': step.isRequired,
      'canSkip': step.canSkip,
    };
  }
  return {};
});
