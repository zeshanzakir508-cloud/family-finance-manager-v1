import '../enums/onboarding_step.dart';
import '../enums/onboarding_status.dart';
import '../models/onboarding_progress_model.dart';
import '../services/onboarding_service.dart';
import '../validators/onboarding_validator.dart';

/// Repository for onboarding data operations
class OnboardingRepository {
  final OnboardingService _service;

  OnboardingRepository(this._service);

  /// Get the current onboarding progress
  Future<OnboardingProgressModel> getProgress() async {
    try {
      final progress = await _service.getProgress();
      
      // Validate and repair progress if needed
      if (!OnboardingValidator.isProgressConsistent(progress)) {
        final repaired = OnboardingValidator.repairProgress(progress);
        await _service.saveProgress(repaired);
        return repaired;
      }
      
      return progress;
    } catch (e) {
      // On error, return initial progress
      return OnboardingProgressModel.initial();
    }
  }

  /// Save onboarding progress
  Future<void> saveProgress(OnboardingProgressModel progress) async {
    // Validate before saving
    final validationResult = OnboardingValidator.validateFlow(progress);
    if (!validationResult.isValid) {
      // Try to repair if possible
      final repaired = OnboardingValidator.repairProgress(progress);
      await _service.saveProgress(repaired);
      return;
    }
    
    await _service.saveProgress(progress);
  }

  /// Mark onboarding as completed
  Future<void> markCompleted() async {
    final progress = await getProgress();
    
    // Validate that all required steps are completed
    if (!progress.areAllRequiredStepsCompleted) {
      throw Exception('Cannot mark as completed: Required steps are not completed');
    }
    
    await _service.markCompleted();
  }

  /// Mark onboarding as skipped
  Future<void> markSkipped() async {
    await _service.markSkipped();
  }

  /// Reset onboarding progress
  Future<void> reset() async {
    await _service.reset();
  }

  /// Check if onboarding is completed
  Future<bool> isCompleted() async {
    return await _service.isCompleted();
  }

  /// Check if onboarding is skipped
  Future<bool> isSkipped() async {
    return await _service.isSkipped();
  }

  /// Check if onboarding is in progress
  Future<bool> isInProgress() async {
    return await _service.isInProgress();
  }

  /// Check if this is the first launch
  Future<bool> isFirstLaunch() async {
    return await _service.isFirstLaunch();
  }

  /// Mark first launch as seen
  Future<void> markFirstLaunchSeen() async {
    await _service.markFirstLaunchSeen();
  }

  /// Get the current step
  Future<OnboardingStep> getCurrentStep() async {
    return await _service.getCurrentStep();
  }

  /// Set the current step
  Future<void> setCurrentStep(OnboardingStep step) async {
    final progress = await getProgress();
    final updatedProgress = progress.goToStep(step);
    await saveProgress(updatedProgress);
  }

  /// Go to the next step
  Future<OnboardingStep> goToNextStep() async {
    final progress = await getProgress();
    
    // Validate current step can be advanced
    if (!OnboardingValidator.canAdvanceToNextStep(progress, progress.currentStep)) {
      throw Exception('Cannot advance: Current step is not valid');
    }
    
    // Mark current step as completed
    final updatedProgress = progress.markStepCompleted(progress.currentStep);
    final nextProgress = updatedProgress.goToNextStep();
    
    await saveProgress(nextProgress);
    return nextProgress.currentStep;
  }

  /// Go to the previous step
  Future<OnboardingStep> goToPreviousStep() async {
    final progress = await getProgress();
    
    if (!OnboardingValidator.canGoBack(progress.currentStep)) {
      throw Exception('Cannot go back from this step');
    }
    
    final previousProgress = progress.goToPreviousStep();
    await saveProgress(previousProgress);
    return previousProgress.currentStep;
  }

  /// Go to a specific step
  Future<OnboardingStep> goToStep(OnboardingStep step) async {
    final progress = await getProgress();
    final updatedProgress = progress.goToStep(step);
    await saveProgress(updatedProgress);
    return updatedProgress.currentStep;
  }

  /// Complete a step
  Future<void> completeStep(OnboardingStep step) async {
    final progress = await getProgress();
    
    // Validate the step
    if (!OnboardingValidator.isValidStep(step, progress)) {
      throw Exception('Step is not valid: $step');
    }
    
    final updatedProgress = progress.markStepCompleted(step);
    await saveProgress(updatedProgress);
  }

  /// Skip a step
  Future<void> skipStep(OnboardingStep step) async {
    final progress = await getProgress();
    
    // Check if step can be skipped
    if (!OnboardingValidator.canSkipStep(step, progress)) {
      throw Exception('Step cannot be skipped: $step');
    }
    
    // Mark step as completed anyway (skipping = completing)
    final updatedProgress = progress.markStepCompleted(step);
    await saveProgress(updatedProgress);
  }

  /// Get completed steps
  Future<List<OnboardingStep>> getCompletedSteps() async {
    return await _service.getCompletedSteps();
  }

  /// Get remaining steps
  Future<List<OnboardingStep>> getRemainingSteps() async {
    return await _service.getRemainingSteps();
  }

  /// Get progress percentage
  Future<double> getProgressPercentage() async {
    return await _service.getProgressPercentage();
  }

  /// Get progress as a formatted string
  Future<String> getProgressString() async {
    final progress = await getProgress();
    return progress.progressPercentage;
  }

  /// Check if all required steps are completed
  Future<bool> areAllRequiredStepsCompleted() async {
    return await _service.areAllRequiredStepsCompleted();
  }

  /// Save metadata
  Future<void> saveMetadata(Map<String, dynamic> metadata) async {
    await _service.saveMetadata(metadata);
  }

  /// Get metadata
  Future<Map<String, dynamic>?> getMetadata() async {
    return await _service.getMetadata();
  }

  /// Save family name
  Future<void> saveFamilyName(String familyName) async {
    await saveMetadata({'familyName': familyName});
  }

  /// Get family name
  Future<String?> getFamilyName() async {
    final metadata = await getMetadata();
    return metadata?['familyName'] as String?;
  }

  /// Save account name
  Future<void> saveAccountName(String accountName) async {
    await saveMetadata({'accountName': accountName});
  }

  /// Get account name
  Future<String?> getAccountName() async {
    final metadata = await getMetadata();
    return metadata?['accountName'] as String?;
  }

  /// Save selected categories
  Future<void> saveSelectedCategories(List<String> categories) async {
    await saveMetadata({'selectedCategories': categories});
  }

  /// Get selected categories
  Future<List<String>> getSelectedCategories() async {
    final metadata = await getMetadata();
    final categories = metadata?['selectedCategories'] as List?;
    if (categories == null) return [];
    return categories.cast<String>();
  }

  /// Save account balance
  Future<void> saveAccountBalance(double balance) async {
    await saveMetadata({'accountBalance': balance});
  }

  /// Get account balance
  Future<double?> getAccountBalance() async {
    final metadata = await getMetadata();
    return metadata?['accountBalance'] as double?;
  }

  /// Check if a specific step is completed
  Future<bool> isStepCompleted(OnboardingStep step) async {
    return await _service.isStepCompleted(step);
  }

  /// Get the total number of steps
  Future<int> getTotalSteps() async {
    return await _service.getTotalSteps();
  }

  /// Get the number of completed steps
  Future<int> getCompletedStepsCount() async {
    return await _service.getCompletedStepsCount();
  }

  /// Get the number of remaining steps
  Future<int> getRemainingStepsCount() async {
    final total = await getTotalSteps();
    final completed = await getCompletedStepsCount();
    return total - completed;
  }

  /// Get the onboarding status
  Future<OnboardingStatus> getStatus() async {
    return await _service.getStatus();
  }

  /// Check if the user can finish onboarding
  Future<bool> canFinish() async {
    final progress = await getProgress();
    return OnboardingValidator.canAdvanceToNextStep(progress, OnboardingStep.finish);
  }

  /// Check if the onboarding can be skipped entirely
  Future<bool> canSkipOnboarding() async {
    final progress = await getProgress();
    return OnboardingValidator.canSkipOnboarding(progress);
  }

  /// Get validation errors for the current step
  Future<List<String>> getCurrentStepErrors() async {
    final progress = await getProgress();
    final errors = <String>[];
    
    if (!OnboardingValidator.isValidCurrentStep(progress)) {
      errors.add('Current step is invalid');
    }
    
    if (!OnboardingValidator.canAdvanceToNextStep(progress, progress.currentStep)) {
      final error = OnboardingValidator.getValidationError(
        progress.currentStep,
        progress,
      );
      if (error != null) {
        errors.add(error);
      }
    }
    
    return errors;
  }

  /// Validate the entire onboarding flow
  Future<OnboardingValidationResult> validateFlow() async {
    final progress = await getProgress();
    return OnboardingValidator.validateFlow(progress);
  }

  /// Get onboarding summary for analytics
  Future<Map<String, dynamic>> getOnboardingSummary() async {
    final progress = await getProgress();
    final status = progress.status;
    final isComplete = status == OnboardingStatus.completed;
    final isSkipped = status == OnboardingStatus.skipped;
    final isInProgress = status == OnboardingStatus.inProgress;
    
    return {
      'status': status.name,
      'statusDisplay': status.displayName,
      'isComplete': isComplete,
      'isSkipped': isSkipped,
      'isInProgress': isInProgress,
      'currentStep': progress.currentStep.name,
      'currentStepDisplay': progress.currentStep.displayName,
      'completedSteps': progress.completedCount,
      'totalSteps': progress.totalSteps,
      'progressPercentage': progress.progressPercentageValue,
      'hasCompletedAllRequired': progress.hasCompletedAllRequiredSteps,
      'startedAt': progress.startedAt?.toIso8601String(),
      'completedAt': progress.completedAt?.toIso8601String(),
      'timeElapsed': progress.formattedTimeElapsed,
      'version': progress.version,
      'hasMetadata': progress.metadata != null && progress.metadata!.isNotEmpty,
      'familyName': progress.metadata?['familyName'],
      'accountName': progress.metadata?['accountName'],
      'selectedCategoriesCount': (progress.metadata?['selectedCategories'] as List?)?.length ?? 0,
    };
  }

  /// Clear all onboarding data
  Future<void> clearAllData() async {
    await _service.clearAllData();
  }

  /// Check if onboarding needs migration
  Future<bool> needsMigration() async {
    return await _service.needsMigration();
  }

  /// Migrate onboarding data
  Future<void> migrate() async {
    await _service.migrate();
  }

  /// Reset stale onboarding
  Future<void> resetStale() async {
    await _service.resetStale();
  }

  /// Get the time elapsed since onboarding started
  Future<Duration?> getTimeElapsed() async {
    return await _service.getTimeElapsed();
  }

  /// Get the time since onboarding was completed
  Future<Duration?> getTimeSinceCompletion() async {
    return await _service.getTimeSinceCompletion();
  }

  /// Get the onboarding version
  Future<String> getVersion() async {
    return await _service.getVersion();
  }

  /// Check if onboarding has data
  Future<bool> hasData() async {
    final progress = await getProgress();
    return progress.status != OnboardingStatus.notStarted;
  }

  /// Get a readable status message
  Future<String> getStatusMessage() async {
    final progress = await getProgress();
    return OnboardingValidator.getCompletionMessage(progress);
  }

  /// Check if the user is near completion (for motivational messages)
  Future<bool> isNearCompletion() async {
    final progress = await getProgress();
    final remaining = progress.remainingRequiredSteps.length;
    return remaining <= 2 && progress.status == OnboardingStatus.inProgress;
  }

  /// Get the next incomplete required step
  Future<OnboardingStep?> getNextIncompleteRequiredStep() async {
    final progress = await getProgress();
    final remainingRequired = progress.remainingRequiredSteps;
    if (remainingRequired.isEmpty) return null;
    
    // Return the first remaining required step
    return remainingRequired.first;
  }

  /// Get the recommended next step
  Future<OnboardingStep> getRecommendedNextStep() async {
    final progress = await getProgress();
    final remainingRequired = progress.remainingRequiredSteps;
    
    if (remainingRequired.isNotEmpty) {
      return remainingRequired.first;
    }
    
    // If no required steps remain, go to finish
    return OnboardingStep.finish;
  }

  /// Check if the repository is ready for operations
  Future<bool> isReady() async {
    try {
      await getStatus();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Handle first launch logic
  Future<bool> handleFirstLaunch() async {
    final isFirst = await isFirstLaunch();
    if (isFirst) {
      await markFirstLaunchSeen();
      return true;
    }
    return false;
  }

  /// Get the current progress as a detailed map
  Future<Map<String, dynamic>> getDetailedProgress() async {
    final progress = await getProgress();
    final status = await getStatus();
    final isComplete = await isCompleted();
    final isSkipped = await isSkipped();
    final isInProgress = await isInProgress();
    
    return {
      'progress': progress.toJson(),
      'status': {
        'current': status.name,
        'display': status.displayName,
        'isComplete': isComplete,
        'isSkipped': isSkipped,
        'isInProgress': isInProgress,
      },
      'steps': {
        'completed': (await getCompletedSteps()).map((s) => s.name).toList(),
        'remaining': (await getRemainingSteps()).map((s) => s.name).toList(),
        'total': await getTotalSteps(),
        'completedCount': await getCompletedStepsCount(),
        'remainingCount': await getRemainingStepsCount(),
        'progressPercentage': await getProgressPercentage(),
      },
      'validation': {
        'isValid': OnboardingValidator.isProgressConsistent(progress),
        'allRequiredCompleted': await areAllRequiredStepsCompleted(),
        'canFinish': await canFinish(),
        'canSkip': await canSkipOnboarding(),
      },
      'metadata': await getMetadata(),
      'timing': {
        'timeElapsed': (await getTimeElapsed())?.inSeconds,
        'timeSinceCompletion': (await getTimeSinceCompletion())?.inSeconds,
        'isStale': await _service.isStale(),
      },
      'version': await getVersion(),
    };
  }
}
