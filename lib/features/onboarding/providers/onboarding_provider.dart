import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/onboarding_repository.dart';
import '../services/onboarding_service.dart';
import '../services/onboarding_storage_service.dart';
import 'onboarding_notifier.dart';
import 'onboarding_state.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be provided');
});

/// Provider for OnboardingService
final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  final preferences = ref.watch(sharedPreferencesProvider);
  return OnboardingStorageService(preferences);
});

/// Provider for OnboardingRepository
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final service = ref.watch(onboardingServiceProvider);
  return OnboardingRepository(service);
});

/// Provider for OnboardingNotifier
final onboardingNotifierProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return OnboardingNotifier(repository);
});

/// Provider for onboarding state (read-only)
final onboardingStateProvider = Provider<OnboardingState>((ref) {
  return ref.watch(onboardingNotifierProvider);
});

/// Provider for onboarding actions
final onboardingActionsProvider = Provider<OnboardingActions>((ref) {
  final notifier = ref.watch(onboardingNotifierProvider.notifier);
  return OnboardingActions(notifier);
});

/// Provider for checking if onboarding is complete
final isOnboardingCompleteProvider = Provider<bool>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state.isCompleted || state.isSkipped;
});

/// Provider for checking if onboarding is in progress
final isOnboardingInProgressProvider = Provider<bool>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state.isInProgress;
});

/// Provider for onboarding progress percentage
final onboardingProgressProvider = Provider<double>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state.progress;
});

/// Provider for current onboarding step
final currentOnboardingStepProvider = Provider<OnboardingStep>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state.currentStep;
});

/// Provider for onboarding current page
final currentOnboardingPageProvider = Provider<OnboardingPageModel?>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state.currentPage;
});

/// Provider for onboarding errors
final onboardingErrorsProvider = Provider<List<String>>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state.errors;
});

/// Provider for onboarding warnings
final onboardingWarningsProvider = Provider<List<String>>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state.warnings;
});

/// Provider for onboarding metadata
final onboardingMetadataProvider = Provider<Map<String, dynamic>?>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state.metadata;
});

/// Provider for checking if onboarding can be advanced
final canAdvanceOnboardingProvider = Provider<bool>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state.canAdvance;
});

/// Provider for checking if onboarding can go back
final canGoBackOnboardingProvider = Provider<bool>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state.canGoBack;
});

/// Provider for checking if onboarding can be skipped
final canSkipOnboardingProvider = Provider<bool>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state.canSkipOnboarding;
});

/// Provider for checking if onboarding can be finished
final canFinishOnboardingProvider = Provider<bool>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state.canFinish;
});

/// Provider for onboarding status message
final onboardingStatusMessageProvider = Provider<String>((ref) {
  final state = ref.watch(onboardingStateProvider);
  if (state.isCompleted) return 'Onboarding complete! 🎉';
  if (state.isSkipped) return 'Onboarding skipped ⏭️';
  if (state.isNotStarted) return 'Ready to start onboarding 🚀';
  return 'Onboarding in progress 📝';
});

/// Provider for onboarding repository (for direct access)
final onboardingRepositoryProviderDirect = Provider<OnboardingRepository>((ref) {
  return ref.watch(onboardingRepositoryProvider);
});

/// Provider for onboarding service (for direct access)
final onboardingServiceProviderDirect = Provider<OnboardingService>((ref) {
  return ref.watch(onboardingServiceProvider);
});

/// Provider for onboarding validation
final onboardingValidatorProvider = Provider<OnboardingValidator>((ref) {
  return OnboardingValidator();
});

/// Provider for onboarding summary
final onboardingSummaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(onboardingRepositoryProvider);
  return await repository.getOnboardingSummary();
});

/// Provider for checking if onboarding needs migration
final onboardingNeedsMigrationProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(onboardingRepositoryProvider);
  return await repository.needsMigration();
});

/// Provider for onboarding time elapsed
final onboardingTimeElapsedProvider = FutureProvider<Duration?>((ref) async {
  final repository = ref.watch(onboardingRepositoryProvider);
  return await repository.getTimeElapsed();
});

/// Provider for onboarding near completion check
final onboardingNearCompletionProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(onboardingRepositoryProvider);
  return await repository.isNearCompletion();
});

/// Provider for getting all onboarding pages
final onboardingAllPagesProvider = Provider<List<OnboardingPageModel>>((ref) {
  return OnboardingPageModel.getAllPages();
});

/// Provider for getting onboarding page by step
final onboardingPageByStepProvider = Provider.family<OnboardingPageModel, OnboardingStep>((ref, step) {
  return OnboardingPageModel.fromStep(step);
});

/// Provider for step completion status
final onboardingStepCompletionProvider = FutureProvider.family<bool, OnboardingStep>((ref, step) async {
  final repository = ref.watch(onboardingRepositoryProvider);
  return await repository.isStepCompleted(step);
});

/// Provider for the next incomplete step
final onboardingNextIncompleteStepProvider = FutureProvider<OnboardingStep?>((ref) async {
  final repository = ref.watch(onboardingRepositoryProvider);
  return await repository.getNextIncompleteRequiredStep();
});

/// Provider for onboarding detailed progress
final onboardingDetailedProgressProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(onboardingRepositoryProvider);
  return await repository.getDetailedProgress();
});

/// Class containing all onboarding actions
class OnboardingActions {
  final OnboardingNotifier _notifier;

  OnboardingActions(this._notifier);

  /// Go to the next step
  Future<void> next() => _notifier.next();

  /// Go to the previous step
  Future<void> back() => _notifier.back();

  /// Go to a specific step
  Future<void> goToStep(OnboardingStep step) => _notifier.goToStep(step);

  /// Complete onboarding
  Future<void> complete() => _notifier.complete();

  /// Skip onboarding
  Future<void> skip() => _notifier.skip();

  /// Reset onboarding
  Future<void> reset() => _notifier.reset();

  /// Complete a specific step
  Future<void> completeStep(OnboardingStep step) => _notifier.completeStep(step);

  /// Skip a specific step
  Future<void> skipStep(OnboardingStep step) => _notifier.skipStep(step);

  /// Save metadata
  Future<void> saveMetadata(Map<String, dynamic> metadata) => _notifier.saveMetadata(metadata);

  /// Save family name
  Future<void> saveFamilyName(String name) => _notifier.saveFamilyName(name);

  /// Save account name
  Future<void> saveAccountName(String name) => _notifier.saveAccountName(name);

  /// Save selected categories
  Future<void> saveSelectedCategories(List<String> categories) => 
      _notifier.saveSelectedCategories(categories);

  /// Save account balance
  Future<void> saveAccountBalance(double balance) => _notifier.saveAccountBalance(balance);

  /// Refresh the state
  Future<void> refresh() => _notifier.refresh();

  /// Initialize onboarding
  Future<void> initialize() => _notifier.initialize();
}
