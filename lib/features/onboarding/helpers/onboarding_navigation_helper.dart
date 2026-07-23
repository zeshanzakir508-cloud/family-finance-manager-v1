import 'package:flutter/material.dart';
import '../enums/onboarding_step.dart';
import '../enums/onboarding_status.dart';
import '../models/onboarding_progress_model.dart';
import '../validators/onboarding_validator.dart';

/// Helper class for onboarding navigation logic
class OnboardingNavigationHelper {
  /// Get the route name for a step
  static String getRouteForStep(OnboardingStep step) {
    return '/onboarding/${step.name}';
  }

  /// Get the route name for onboarding home
  static const String onboardingHomeRoute = '/onboarding';

  /// Get the route name for splash redirect
  static const String splashRoute = '/splash';

  /// Get the route name for dashboard
  static const String dashboardRoute = '/dashboard';

  /// Check if a route is an onboarding route
  static bool isOnboardingRoute(String route) {
    return route.startsWith('/onboarding');
  }

  /// Get the step from a route
  static OnboardingStep? getStepFromRoute(String route) {
    final parts = route.split('/');
    if (parts.length < 3) return null;
    
    final stepName = parts.last;
    try {
      return OnboardingStep.values.firstWhere(
        (step) => step.name == stepName,
      );
    } catch (e) {
      return null;
    }
  }

  /// Determine the redirect route based on onboarding state
  static String getRedirectRoute(OnboardingProgressModel progress) {
    if (progress.status == OnboardingStatus.completed ||
        progress.status == OnboardingStatus.skipped) {
      return dashboardRoute;
    }
    return onboardingHomeRoute;
  }

  /// Determine if navigation should redirect to onboarding
  static bool shouldRedirectToOnboarding(OnboardingProgressModel progress) {
    return !OnboardingValidator.isOnboardingComplete(progress);
  }

  /// Determine if navigation should redirect to dashboard
  static bool shouldRedirectToDashboard(OnboardingProgressModel progress) {
    return OnboardingValidator.isOnboardingComplete(progress);
  }

  /// Get the appropriate initial route based on first launch and completion status
  static String getInitialRoute(bool isFirstLaunch, bool isCompleted) {
    if (isFirstLaunch && !isCompleted) {
      return onboardingHomeRoute;
    }
    return dashboardRoute;
  }

  /// Get navigation parameters for a step
  static Map<String, dynamic> getStepNavigationParams(OnboardingStep step) {
    return {
      'step': step.name,
      'stepIndex': step.index,
      'stepTitle': step.displayName,
      'isRequired': step.isRequired,
      'canSkip': step.canSkip,
    };
  }

  /// Check if a route transition should be animated
  static bool shouldAnimateTransition(OnboardingStep from, OnboardingStep to) {
    // Always animate between onboarding steps
    return true;
  }

  /// Get the navigation direction based on step order
  static PageRouteBuilder? getPageRouteBuilder(
    Widget page,
    OnboardingStep from,
    OnboardingStep to,
  ) {
    if (from.index < to.index) {
      // Forward navigation (right to left)
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      );
    } else {
      // Backward navigation (left to right)
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      );
    }
  }

  /// Get a fade transition route
  static PageRouteBuilder getFadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
        var fadeAnimation = animation.drive(tween);
        return FadeTransition(opacity: fadeAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  /// Get a scale transition route
  static PageRouteBuilder getScaleRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeOutCubic;
        var tween = Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve));
        var scaleAnimation = animation.drive(tween);
        return ScaleTransition(scale: scaleAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  /// Determine if navigation should pop
  static bool shouldPop(OnboardingProgressModel progress) {
    return progress.currentStep != OnboardingStep.welcome;
  }

  /// Get the page to navigate to on pop
  static OnboardingStep getPopDestination(OnboardingProgressModel progress) {
    return progress.currentStep.previous ?? OnboardingStep.welcome;
  }

  /// Check if a deep link should be handled by onboarding
  static bool shouldHandleDeepLink(String uri) {
    final uriParsed = Uri.parse(uri);
    return uriParsed.path.startsWith('/onboarding');
  }

  /// Get the step from a deep link
  static OnboardingStep? getStepFromDeepLink(String uri) {
    final uriParsed = Uri.parse(uri);
    final path = uriParsed.path;
    if (path == '/onboarding') return null;
    
    final parts = path.split('/');
    if (parts.length < 3) return null;
    
    return getStepFromRoute(path);
  }

  /// Build the onboarding route path for a step
  static String buildRoutePath(OnboardingStep step) {
    return '/onboarding/${step.name}';
  }

  /// Check if the route is the onboarding home
  static bool isOnboardingHomeRoute(String route) {
    return route == onboardingHomeRoute;
  }

  /// Get all onboarding routes
  static List<String> getAllOnboardingRoutes() {
    return OnboardingStep.values.map((step) => buildRoutePath(step)).toList();
  }

  /// Get the route to redirect to from onboarding
  static String getExitRoute(OnboardingProgressModel progress) {
    if (progress.isComplete) {
      return dashboardRoute;
    }
    if (progress.isSkipped) {
      return dashboardRoute;
    }
    return onboardingHomeRoute;
  }

  /// Check if navigation should skip animation for a step
  static bool shouldSkipAnimation(OnboardingStep step) {
    // Skip animation for welcome and finish steps
    return step == OnboardingStep.welcome || step == OnboardingStep.finish;
  }

  /// Get navigation data for analytics
  static Map<String, dynamic> getNavigationAnalytics(
    OnboardingStep from,
    OnboardingStep to,
  ) {
    return {
      'from_step': from.name,
      'from_index': from.index,
      'to_step': to.name,
      'to_index': to.index,
      'direction': from.index < to.index ? 'forward' : 'backward',
      'steps_moved': (to.index - from.index).abs(),
      'is_forward': from.index < to.index,
    };
  }

  /// Check if a route is accessible given the current progress
  static bool isRouteAccessible(
    String route,
    OnboardingProgressModel progress,
  ) {
    final step = getStepFromRoute(route);
    if (step == null) return true;
    
    // Can access current step or any completed step
    if (step == progress.currentStep || progress.isStepCompleted(step)) {
      return true;
    }
    
    // Can access finish step if all required steps are completed
    if (step == OnboardingStep.finish && progress.areAllRequiredStepsCompleted) {
      return true;
    }
    
    // Can access any step that is before the current step
    if (step.isBefore(progress.currentStep)) {
      return true;
    }
    
    // Can access any step that is the next incomplete step
    if (step == progress.nextIncompleteStep) {
      return true;
    }
    
    return false;
  }

  /// Get the recommended route for a given progress state
  static String getRecommendedRoute(OnboardingProgressModel progress) {
    if (progress.isComplete || progress.isSkipped) {
      return dashboardRoute;
    }
    
    final nextIncomplete = progress.nextIncompleteStep;
    if (nextIncomplete != null) {
      return buildRoutePath(nextIncomplete);
    }
    
    return buildRoutePath(progress.currentStep);
  }

  /// Check if the current route matches the recommended route
  static bool isOnRecommendedRoute(
    String currentRoute,
    OnboardingProgressModel progress,
  ) {
    final recommended = getRecommendedRoute(progress);
    return currentRoute == recommended;
  }

  /// Get navigation breadcrumbs for the current progress
  static List<Map<String, dynamic>> getNavigationBreadcrumbs(
    OnboardingProgressModel progress,
  ) {
    final breadcrumbs = <Map<String, dynamic>>[];
    final allSteps = OnboardingStep.values;
    
    for (var i = 0; i < allSteps.length; i++) {
      final step = allSteps[i];
      final isCompleted = progress.isStepCompleted(step);
      final isCurrent = step == progress.currentStep;
      
      breadcrumbs.add({
        'step': step.name,
        'displayName': step.displayName,
        'index': i,
        'isCompleted': isCompleted,
        'isCurrent': isCurrent,
        'isAccessible': isCompleted || isCurrent || step.isBefore(progress.currentStep),
        'isRequired': step.isRequired,
      });
    }
    
    return breadcrumbs;
  }

  /// Get the next route in the sequence
  static String? getNextRoute(OnboardingProgressModel progress) {
    final next = progress.currentStep.next;
    if (next == null) return null;
    return buildRoutePath(next);
  }

  /// Get the previous route in the sequence
  static String? getPreviousRoute(OnboardingProgressModel progress) {
    final previous = progress.currentStep.previous;
    if (previous == null) return null;
    return buildRoutePath(previous);
  }
}
