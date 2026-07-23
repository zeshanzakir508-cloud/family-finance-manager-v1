import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../enums/onboarding_step.dart';
import '../../models/onboarding_page_model.dart';
import '../../providers/onboarding_provider.dart';
import '../sections/page_indicator_section.dart';
import '../sections/progress_indicator_section.dart';
import '../widgets/back_button.dart';
import '../widgets/next_button.dart';
import '../widgets/skip_button.dart';
import 'intro_page.dart';
import 'permissions_page.dart';
import 'terms_privacy_page.dart';
import 'family_setup_page.dart';
import 'account_setup_page.dart';
import 'category_setup_page.dart';
import 'finish_onboarding_page.dart';

/// Main onboarding page with page view and navigation
class OnboardingPage extends ConsumerStatefulWidget {
  final OnboardingStep? initialStep;

  const OnboardingPage({super.key, this.initialStep});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late PageController _pageController;
  OnboardingStep _currentStep = OnboardingStep.welcome;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    final initialStep = widget.initialStep ?? OnboardingStep.welcome;
    _currentStep = initialStep;
    _pageController = PageController(
      initialPage: initialStep.index,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_isAnimating) return;
    
    final step = OnboardingStep.values[index];
    setState(() {
      _currentStep = step;
    });
    
    // Update provider state
    ref.read(onboardingNotifierProvider.notifier).goToStep(step);
  }

  Future<void> _navigateToStep(OnboardingStep step) async {
    if (_isAnimating) return;
    
    setState(() {
      _isAnimating = true;
    });

    await _pageController.animateToPage(
      step.index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );

    setState(() {
      _currentStep = step;
      _isAnimating = false;
    });
  }

  Widget _buildPageForStep(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.welcome:
        return const IntroPage();
      case OnboardingStep.permissions:
        return const PermissionsPage();
      case OnboardingStep.terms:
        return const TermsPrivacyPage();
      case OnboardingStep.family:
        return const FamilySetupPage();
      case OnboardingStep.accounts:
        return const AccountSetupPage();
      case OnboardingStep.categories:
        return const CategorySetupPage();
      case OnboardingStep.finish:
        return const FinishOnboardingPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingStateProvider);
    
    // If onboarding is complete, redirect to dashboard
    if (state.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            ProgressIndicatorSection(
              progress: state.progress,
              currentStep: _currentStep,
              totalSteps: state.totalSteps,
            ),
            
            // Page view
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: const NeverScrollableScrollPhysics(),
                children: OnboardingStep.values
                    .map((step) => _buildPageForStep(step))
                    .toList(),
              ),
            ),
            
            // Bottom navigation
            _buildBottomNavigation(state),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(OnboardingState state) {
    final isFirstStep = _currentStep == OnboardingStep.welcome;
    final isLastStep = _currentStep == OnboardingStep.finish;
    final canSkip = _currentStep.canSkip && !isLastStep;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          if (!isFirstStep)
            OnboardingBackButton(
              onPressed: () {
                final previous = _currentStep.previous;
                if (previous != null) {
                  _navigateToStep(previous);
                }
              },
            )
          else
            const SizedBox(width: 80),
          
          // Page indicator
          PageIndicatorSection(
            currentIndex: _currentStep.index,
            totalPages: state.totalSteps,
          ),
          
          // Skip or Next button
          if (isLastStep)
            OnboardingNextButton(
              text: 'Finish',
              onPressed: () async {
                await ref.read(onboardingNotifierProvider.notifier).complete();
              },
            )
          else if (canSkip)
            Row(
              children: [
                OnboardingSkipButton(
                  onPressed: () {
                    _showSkipConfirmation();
                  },
                ),
                const SizedBox(width: 8),
                OnboardingNextButton(
                  text: 'Next',
                  onPressed: () {
                    final next = _currentStep.next;
                    if (next != null) {
                      _navigateToStep(next);
                    }
                  },
                ),
              ],
            )
          else
            OnboardingNextButton(
              text: 'Next',
              onPressed: () {
                final next = _currentStep.next;
                if (next != null) {
                  _navigateToStep(next);
                }
              },
            ),
        ],
      ),
    );
  }

  void _showSkipConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skip Step?'),
        content: const Text(
          'Are you sure you want to skip this step? You can always come back and complete it later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Skip the step
              ref.read(onboardingNotifierProvider.notifier).skipStep(_currentStep);
              final next = _currentStep.next;
              if (next != null) {
                _navigateToStep(next);
              }
            },
            child: const Text('Skip', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
