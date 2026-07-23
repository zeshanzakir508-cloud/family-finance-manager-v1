import '../enums/onboarding_step.dart';
import '../enums/onboarding_status.dart';
import '../models/onboarding_progress_model.dart';

/// Interface for onboarding operations
abstract class OnboardingService {
  /// Get the current onboarding status
  Future<OnboardingStatus> getStatus();

  /// Get the current onboarding progress
  Future<OnboardingProgressModel> getProgress();

  /// Save onboarding progress
  Future<void> saveProgress(OnboardingProgressModel progress);

  /// Mark onboarding as completed
  Future<void> markCompleted();

  /// Mark onboarding as skipped
  Future<void> markSkipped();

  /// Reset onboarding progress
  Future<void> reset();

  /// Check if onboarding has been completed
  Future<bool> isCompleted();

  /// Check if onboarding has been skipped
  Future<bool> isSkipped();

  /// Check if onboarding is in progress
  Future<bool> isInProgress();

  /// Check if this is the first launch
  Future<bool> isFirstLaunch();

  /// Mark first launch as seen
  Future<void> markFirstLaunchSeen();

  /// Get the current step
  Future<OnboardingStep> getCurrentStep();

  /// Update the current step
  Future<void> setCurrentStep(OnboardingStep step);

  /// Mark a step as completed
  Future<void> markStepCompleted(OnboardingStep step);

  /// Mark a step as incomplete
  Future<void> markStepIncomplete(OnboardingStep step);

  /// Check if a step is completed
  Future<bool> isStepCompleted(OnboardingStep step);

  /// Get all completed steps
  Future<List<OnboardingStep>> getCompletedSteps();

  /// Get progress percentage (0.0 - 1.0)
  Future<double> getProgressPercentage();

  /// Get the number of completed steps
  Future<int> getCompletedStepsCount();

  /// Get the total number of steps
  Future<int> getTotalSteps();

  /// Get remaining steps
  Future<List<OnboardingStep>> getRemainingSteps();

  /// Check if all required steps are completed
  Future<bool> areAllRequiredStepsCompleted();

  /// Save custom metadata
  Future<void> saveMetadata(Map<String, dynamic> metadata);

  /// Get custom metadata
  Future<Map<String, dynamic>?> getMetadata();

  /// Clear all onboarding data
  Future<void> clearAllData();

  /// Get the onboarding version
  Future<String> getVersion();

  /// Check if onboarding needs migration
  Future<bool> needsMigration();

  /// Migrate onboarding data to latest version
  Future<void> migrate();

  /// Get the time elapsed since onboarding started
  Future<Duration?> getTimeElapsed();

  /// Get the time since onboarding was completed
  Future<Duration?> getTimeSinceCompletion();

  /// Check if onboarding is stale (took too long)
  Future<bool> isStale();

  /// Reset stale onboarding
  Future<void> resetStale();
}
