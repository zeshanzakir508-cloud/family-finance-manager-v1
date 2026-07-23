import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';
import '../widgets/onboarding_image.dart';

/// Splash redirect page that checks first launch status and redirects accordingly
class SplashRedirectPage extends ConsumerStatefulWidget {
  const SplashRedirectPage({super.key});

  @override
  ConsumerState<SplashRedirectPage> createState() => _SplashRedirectPageState();
}

class _SplashRedirectPageState extends ConsumerState<SplashRedirectPage> {
  bool _isLoading = true;
  String _statusMessage = 'Checking your setup...';

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      // Wait for onboarding provider to initialize
      await ref.read(onboardingNotifierProvider.notifier).initialize();
      
      final state = ref.read(onboardingStateProvider);
      
      if (mounted) {
        if (state.isCompleted || state.isSkipped) {
          _statusMessage = 'Welcome back! Redirecting...';
          _navigateToDashboard();
        } else {
          _statusMessage = 'Setting up your experience...';
          _navigateToOnboarding();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = 'Something went wrong. Please try again.';
        });
      }
    }
  }

  void _navigateToDashboard() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    });
  }

  void _navigateToOnboarding() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade700],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                // App Name
                const Text(
                  'Family Budget',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your family finances together',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 48),
                // Loading indicator
                if (_isLoading) ...[
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _statusMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ] else ...[
                  // Error state
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _statusMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red.shade400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  OnboardingButton(
                    text: 'Retry',
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _statusMessage = 'Retrying...';
                      });
                      _checkOnboardingStatus();
                    },
                    type: OnboardingButtonType.primary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
