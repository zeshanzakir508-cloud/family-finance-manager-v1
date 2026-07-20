import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Onboarding controller state.
class OnboardingState {
  final int currentPage;
  final bool isLoading;
  final bool hasSeenOnboarding;
  final bool hasAcceptedTerms;
  final bool hasAcceptedPrivacy;
  final bool isComplete;

  const OnboardingState({
    this.currentPage = 0,
    this.isLoading = false,
    this.hasSeenOnboarding = false,
    this.hasAcceptedTerms = false,
    this.hasAcceptedPrivacy = false,
    this.isComplete = false,
  });

  OnboardingState copyWith({
    int? currentPage,
    bool? isLoading,
    bool? hasSeenOnboarding,
    bool? hasAcceptedTerms,
    bool? hasAcceptedPrivacy,
    bool? isComplete,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      hasAcceptedPrivacy: hasAcceptedPrivacy ?? this.hasAcceptedPrivacy,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  bool get canProceed => hasAcceptedTerms && hasAcceptedPrivacy;
}

/// Onboarding controller notifier.
class OnboardingController extends StateNotifier<OnboardingState> {
  static const String _onboardingKey = 'onboarding_completed';
  static const String _termsAcceptedKey = 'terms_accepted';
  static const String _privacyAcceptedKey = 'privacy_accepted';

  final SharedPreferences _prefs;

  OnboardingController(this._prefs) : super(const OnboardingState()) {
    _loadOnboardingStatus();
  }

  /// Loads onboarding status from shared preferences.
  Future<void> _loadOnboardingStatus() async {
    final hasSeen = _prefs.getBool(_onboardingKey) ?? false;
    final termsAccepted = _prefs.getBool(_termsAcceptedKey) ?? false;
    final privacyAccepted = _prefs.getBool(_privacyAcceptedKey) ?? false;

    state = state.copyWith(
      hasSeenOnboarding: hasSeen,
      hasAcceptedTerms: termsAccepted,
      hasAcceptedPrivacy: privacyAccepted,
      isComplete: hasSeen && termsAccepted && privacyAccepted,
    );
  }

  /// Goes to the next page.
  void nextPage() {
    state = state.copyWith(
      currentPage: state.currentPage + 1,
    );
  }

  /// Goes to the previous page.
  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(
        currentPage: state.currentPage - 1,
      );
    }
  }

  /// Goes to a specific page.
  void goToPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  /// Accepts terms and conditions.
  void acceptTerms() {
    state = state.copyWith(hasAcceptedTerms: true);
    _prefs.setBool(_termsAcceptedKey, true);
    _checkCompletion();
  }

  /// Accepts privacy policy.
  void acceptPrivacy() {
    state = state.copyWith(hasAcceptedPrivacy: true);
    _prefs.setBool(_privacyAcceptedKey, true);
    _checkCompletion();
  }

  /// Accepts all terms and conditions.
  void acceptAll() {
    state = state.copyWith(
      hasAcceptedTerms: true,
      hasAcceptedPrivacy: true,
    );
    _prefs.setBool(_termsAcceptedKey, true);
    _prefs.setBool(_privacyAcceptedKey, true);
    _checkCompletion();
  }

  /// Completes onboarding.
  Future<void> completeOnboarding() async {
    if (!state.canProceed) return;

    state = state.copyWith(isLoading: true);

    try {
      await _prefs.setBool(_onboardingKey, true);
      state = state.copyWith(
        hasSeenOnboarding: true,
        isComplete: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// Checks if onboarding is complete.
  void _checkCompletion() {
    final complete = state.hasSeenOnboarding &&
        state.hasAcceptedTerms &&
        state.hasAcceptedPrivacy;
    state = state.copyWith(isComplete: complete);
  }

  /// Returns true if onboarding is complete.
  bool get isOnboardingComplete => state.isComplete;

  /// Returns true if user can proceed to next page.
  bool get canProceed => state.canProceed;

  /// Resets onboarding state (for testing).
  Future<void> reset() async {
    await _prefs.remove(_onboardingKey);
    await _prefs.remove(_termsAcceptedKey);
    await _prefs.remove(_privacyAcceptedKey);
    state = const OnboardingState();
  }

  /// Gets the current page index.
  int get currentPage => state.currentPage;

  /// Gets the total number of pages.
  int get totalPages => 4; // Introduction, Permissions, Theme, Finish
}

/// Provider for OnboardingController.
final onboardingControllerProvider = StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingController(prefs);
});
