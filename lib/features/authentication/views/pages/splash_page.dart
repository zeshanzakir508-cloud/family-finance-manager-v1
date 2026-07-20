import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/splash_provider.dart';
import '../../providers/auth_state_provider.dart';
import '../../enums/auth_status.dart';
import '../../helpers/auth_redirect_helper.dart';
import '../../routes/authentication_routes.dart';
import '../../../onboarding/providers/onboarding_provider.dart';

/// Splash screen that displays while the app initializes.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize splash provider
    final splashNotifier = ref.read(splashNotifierProvider.notifier);
    await splashNotifier.initialize();

    // Get the result
    final state = ref.read(splashStateProvider);
    final authState = ref.read(authStateNotifierProvider);

    // Wait a moment for splash animation
    await Future.delayed(const Duration(milliseconds: 500));

    // Check onboarding status
    final onboardingController = ref.read(onboardingControllerProvider.notifier);
    final hasSeenOnboarding = onboardingController.state.hasSeenOnboarding;

    // Navigate based on auth status
    if (!mounted) return;

    if (state.result == AuthStatus.authenticated) {
      // User is authenticated, go to dashboard
      context.go('/dashboard');
    } else if (state.result == AuthStatus.unverified) {
      // User is logged in but email not verified
      final email = authState.session?.email ?? '';
      context.go(
        AuthenticationRoutes.getVerifyEmailRoute(email: email),
      );
    } else if (state.result == AuthStatus.blocked) {
      // User account is blocked
      context.go(AuthRoutes.accountBlocked);
    } else if (state.result == AuthStatus.failed) {
      // Something went wrong, go to login
      context.go(AuthRoutes.login);
    } else {
      // User is not authenticated
      if (hasSeenOnboarding) {
        // Onboarding already seen, go to login
        context.go(AuthRoutes.login);
      } else {
        // Show onboarding for first-time users
        context.go(AuthRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            const Spacer(flex: 2),
            
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.attach_money,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App Name
            Text(
              'Family Finance Manager',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Manage your family finances',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            
            const Spacer(flex: 1),
            
            // Loading indicator
            const CircularProgressIndicator(),
            
            const SizedBox(height: 16),
            
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
            
            const Spacer(flex: 2),
            
            // Version
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                  ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
