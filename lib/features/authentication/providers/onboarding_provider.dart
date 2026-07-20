import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Onboarding state class.
class OnboardingState {
  final bool hasSeenOnboarding;
  final bool hasAcceptedTerms;
  final int currentPage;
  final bool isLoading;

  const OnboardingState({
    this.hasSeenOnboarding = false,
    this.hasAcceptedTerms = false,
    this.currentPage = 0,
    this.isLoading = false,
  });

  OnboardingState copyWith({
    bool? hasSeenOnboarding,
    bool? hasAcceptedTerms,
    int? currentPage,
    bool? isLoading,
  }) {
    return OnboardingState(
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get isComplete => hasSeenOnboarding && hasAcceptedTerms;
}

/// Provider for onboarding state.
final onboardingStateProvider = StateProvider<OnboardingState>((ref) {
  return const OnboardingState();
});

/// Notifier provider for onboarding logic.
final onboardingNotifierProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref);
});

/// Onboarding notifier for managing onboarding state.
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref ref;

  OnboardingNotifier(this.ref) : super(const OnboardingState());

  /// Sets the current page.
  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  /// Goes to next page.
  void nextPage() {
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  /// Goes to previous page.
  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  /// Marks onboarding as seen.
  void markOnboardingSeen() {
    state = state.copyWith(hasSeenOnboarding: true);
  }

  /// Accepts terms and conditions.
  void acceptTerms() {
    state = state.copyWith(hasAcceptedTerms: true);
  }

  /// Completes onboarding.
  Future<void> completeOnboarding() async {
    try {
      state = state.copyWith(isLoading: true);

      // Save onboarding completion status
      // TODO: Implement with SharedPreferencesProvider
      // final prefs = ref.read(sharedPreferencesProvider);
      // await prefs.setBool('onboarding_complete', true);

      state = state.copyWith(
        hasSeenOnboarding: true,
        hasAcceptedTerms: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// Resets onboarding (for testing or re-onboarding).
  void reset() {
    state = const OnboardingState();
  }

  /// Returns true if onboarding is complete.
  bool get isComplete => state.isComplete;

  /// Returns true if user can proceed.
  bool get canProceed => state.hasAcceptedTerms;
}
