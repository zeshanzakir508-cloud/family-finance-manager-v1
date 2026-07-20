import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/onboarding_provider.dart';
import '../../routes/authentication_routes.dart';
import '../sections/terms_section.dart';

/// Onboarding page for first-time users.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          // Page View
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                controller.goToPage(page);
              },
              children: const [
                _OnboardingPageContent(
                  title: 'Welcome to Family Finance',
                  description: 'Manage your family\'s finances in one place',
                  icon: Icons.family_restroom,
                  color: Colors.blue,
                ),
                _OnboardingPageContent(
                  title: 'Track Expenses',
                  description: 'Easily track all your expenses and income',
                  icon: Icons.trending_up,
                  color: Colors.green,
                ),
                _OnboardingPageContent(
                  title: 'Set Budgets',
                  description: 'Create budgets and stay on track',
                  icon: Icons.account_balance_wallet,
                  color: Colors.orange,
                ),
                _OnboardingPageContent(
                  title: 'Ready to Start',
                  description: 'Accept terms and start managing your finances',
                  icon: Icons.check_circle,
                  color: Colors.purple,
                ),
              ],
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Terms section (only on last page)
                if (state.currentPage == 3) ...[
                  TermsSection(
                    onTermsAccepted: (accepted) {
                      if (accepted) {
                        controller.acceptTerms();
                      }
                    },
                    onPrivacyAccepted: (accepted) {
                      if (accepted) {
                        controller.acceptPrivacy();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Page indicator and buttons
                Row(
                  children: [
                    // Page indicator
                    Expanded(
                      child: Row(
                        children: List.generate(
                          4,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: state.currentPage == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Navigation buttons
                    if (state.currentPage < 3)
                      ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Next'),
                      )
                    else
                      ElevatedButton(
                        onPressed: state.canProceed && !state.isLoading
                            ? () async {
                                await controller.completeOnboarding();
                                if (mounted) {
                                  context.go(AuthRoutes.login);
                                }
                              }
                            : null,
                        child: state.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Get Started'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Onboarding page content widget.
class _OnboardingPageContent extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _OnboardingPageContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              size: 60,
              color: color,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
