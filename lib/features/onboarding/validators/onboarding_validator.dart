import '../enums/onboarding_step.dart';
import '../enums/onboarding_status.dart';
import '../models/onboarding_progress_model.dart';
import '../models/onboarding_page_model.dart';

/// Validator class for onboarding-related validation
class OnboardingValidator {
  /// Validate if onboarding is complete
  static bool isOnboardingComplete(OnboardingProgressModel progress) {
    return progress.status == OnboardingStatus.completed ||
        progress.status == OnboardingStatus.skipped;
  }

  /// Validate if all required steps are completed
  static bool areRequiredStepsCompleted(OnboardingProgressModel progress) {
    return progress.areAllRequiredStepsCompleted;
  }

  /// Validate if terms are accepted
  static bool areTermsAccepted(OnboardingProgressModel progress) {
    return progress.isStepCompleted(OnboardingStep.terms);
  }

  /// Validate if permissions are granted
  static bool arePermissionsGranted(OnboardingProgressModel progress) {
    // Check if permissions step is completed
    return progress.isStepCompleted(OnboardingStep.permissions);
  }

  /// Validate if account is created
  static bool isAccountCreated(OnboardingProgressModel progress) {
    return progress.isStepCompleted(OnboardingStep.accounts);
  }

  /// Validate if current step can be advanced
  static bool canAdvanceToNextStep(
    OnboardingProgressModel progress,
    OnboardingStep currentStep,
  ) {
    // If onboarding is complete, cannot advance
    if (isOnboardingComplete(progress)) return false;

    // If current step requires validation, check it
    if (currentStep.requiresValidation) {
      return isValidStep(currentStep, progress);
    }

    // Always can advance from welcome and finish steps
    if (currentStep == OnboardingStep.welcome) return true;
    if (currentStep == OnboardingStep.finish) return true;

    // For optional steps, can always advance
    return true;
  }

  /// Validate a specific step
  static bool isValidStep(
    OnboardingStep step,
    OnboardingProgressModel progress,
  ) {
    switch (step) {
      case OnboardingStep.welcome:
        return true;
      case OnboardingStep.permissions:
        return validatePermissions(progress);
      case OnboardingStep.terms:
        return validateTerms(progress);
      case OnboardingStep.family:
        return validateFamilySetup(progress);
      case OnboardingStep.accounts:
        return validateAccountSetup(progress);
      case OnboardingStep.categories:
        return validateCategories(progress);
      case OnboardingStep.finish:
        return validateFinish(progress);
    }
  }

  /// Validate permissions step
  static bool validatePermissions(OnboardingProgressModel progress) {
    // This is a placeholder - actual permission checking would be done
    // through the permission service. For now, we check if the step is marked
    // as completed in progress.
    return progress.isStepCompleted(OnboardingStep.permissions);
  }

  /// Validate terms step
  static bool validateTerms(OnboardingProgressModel progress) {
    // Terms validation - check if terms step is completed
    return progress.isStepCompleted(OnboardingStep.terms);
  }

  /// Validate family setup step
  static bool validateFamilySetup(OnboardingProgressModel progress) {
    // Family setup is optional, so it's always valid
    // But we can check if the user has a family name if they chose to set one up
    final metadata = progress.metadata;
    if (metadata != null && metadata.containsKey('familyName')) {
      final familyName = metadata['familyName'] as String?;
      return familyName != null && familyName.isNotEmpty;
    }
    return true; // Optional step, so valid even if skipped
  }

  /// Validate account setup step
  static bool validateAccountSetup(OnboardingProgressModel progress) {
    // Check if account is created
    return progress.isStepCompleted(OnboardingStep.accounts);
  }

  /// Validate categories step
  static bool validateCategories(OnboardingProgressModel progress) {
    // Categories are optional, but if selected, need at least one
    final metadata = progress.metadata;
    if (metadata != null && metadata.containsKey('selectedCategories')) {
      final categories = metadata['selectedCategories'] as List?;
      if (categories != null) {
        return categories.isNotEmpty;
      }
    }
    return true; // Optional step, so valid even if skipped
  }

  /// Validate finish step
  static bool validateFinish(OnboardingProgressModel progress) {
    // Finish step requires all required steps to be completed
    return areRequiredStepsCompleted(progress);
  }

  /// Validate if user can skip current step
  static bool canSkipStep(
    OnboardingStep step,
    OnboardingProgressModel progress,
  ) {
    // Cannot skip if onboarding is complete
    if (isOnboardingComplete(progress)) return false;

    // Cannot skip if step doesn't allow skipping
    if (!step.canSkip) return false;

    // Cannot skip if step is required
    if (step.isRequired && !step.canSkip) return false;

    // For all other cases, can skip
    return true;
  }

  /// Validate if user can go back from current step
  static bool canGoBack(OnboardingStep currentStep) {
    // Cannot go back from welcome step
    if (currentStep == OnboardingStep.welcome) return false;

    // Can go back from all other steps
    return true;
  }

  /// Validate if onboarding can be reset
  static bool canReset(OnboardingProgressModel progress) {
    // Can reset from any status except notStarted
    return progress.status != OnboardingStatus.notStarted;
  }

  /// Validate if onboarding can be skipped entirely
  static bool canSkipOnboarding(OnboardingProgressModel progress) {
    // Cannot skip if already completed or skipped
    if (isOnboardingComplete(progress)) return false;

    // Cannot skip if not started
    if (progress.status == OnboardingStatus.notStarted) return false;

    // Can skip from any in-progress state
    return true;
  }

  /// Validate if current step is valid to display
  static bool isValidCurrentStep(OnboardingProgressModel progress) {
    final currentStep = progress.currentStep;
    final stepIndex = currentStep.index;

    // Check if step index is within bounds
    if (stepIndex < 0 || stepIndex >= OnboardingStep.values.length) {
      return false;
    }

    // Check if the step is completed or can be visited
    final hasPreviousSteps = stepIndex == 0 ||
        progress.completedSteps.any((index) => index < stepIndex);

    return hasPreviousSteps || currentStep == OnboardingStep.welcome;
  }

  /// Validate if progress is consistent
  static bool isProgressConsistent(OnboardingProgressModel progress) {
    // Check if completed steps are within valid range
    final maxIndex = OnboardingStep.values.length - 1;
    for (final stepIndex in progress.completedSteps) {
      if (stepIndex < 0 || stepIndex > maxIndex) {
        return false;
      }
    }

    // Check if current step is within valid range
    final currentIndex = progress.currentStep.index;
    if (currentIndex < 0 || currentIndex > maxIndex) {
      return false;
    }

    // Check if there are duplicate completed steps
    final uniqueSteps = progress.completedSteps.toSet();
    if (uniqueSteps.length != progress.completedSteps.length) {
      return false;
    }

    return true;
  }

  /// Get validation error message for a step
  static String? getValidationError(
    OnboardingStep step,
    OnboardingProgressModel progress,
  ) {
    if (isValidStep(step, progress)) return null;

    switch (step) {
      case OnboardingStep.welcome:
        return null;
      case OnboardingStep.permissions:
        return 'Please grant the required permissions to continue.';
      case OnboardingStep.terms:
        return 'Please accept the Terms of Service to continue.';
      case OnboardingStep.family:
        return 'Please set up your family or skip this step.';
      case OnboardingStep.accounts:
        return 'Please create your account to continue.';
      case OnboardingStep.categories:
        return 'Please select at least one category or skip this step.';
      case OnboardingStep.finish:
        return 'Please complete all required steps before finishing.';
    }
  }

  /// Get completion status message
  static String getCompletionMessage(OnboardingProgressModel progress) {
    if (progress.status == OnboardingStatus.completed) {
      return 'Onboarding completed successfully!';
    } else if (progress.status == OnboardingStatus.skipped) {
      return 'Onboarding was skipped. You can complete it later.';
    } else if (progress.status == OnboardingStatus.inProgress) {
      final remaining = progress.remainingRequiredSteps.length;
      if (remaining == 0) {
        return 'All required steps completed. Finish onboarding!';
      } else {
        return '$remaining step(s) remaining to complete.';
      }
    } else {
      return 'Ready to start onboarding.';
    }
  }

  /// Validate if onboarding should be shown based on first launch
  static bool shouldShowOnboarding(bool isFirstLaunch, bool hasCompleted) {
    return isFirstLaunch && !hasCompleted;
  }

  /// Validate if redirect should go to dashboard
  static bool shouldRedirectToDashboard(OnboardingProgressModel progress) {
    return isOnboardingComplete(progress);
  }

  /// Validate if redirect should go to onboarding
  static bool shouldRedirectToOnboarding(OnboardingProgressModel progress) {
    return !isOnboardingComplete(progress);
  }

  /// Validate the overall onboarding flow
  static OnboardingValidationResult validateFlow(
    OnboardingProgressModel progress,
  ) {
    final List<String> errors = [];
    final List<String> warnings = [];

    // Check progress consistency
    if (!isProgressConsistent(progress)) {
      errors.add('Progress is inconsistent');
    }

    // Check if all required steps are completed for completed status
    if (progress.status == OnboardingStatus.completed) {
      if (!areRequiredStepsCompleted(progress)) {
        errors.add('Onboarding marked as completed but required steps are missing');
      }
    }

    // Check if terms are accepted
    if (progress.status == OnboardingStatus.completed ||
        progress.status == OnboardingStatus.inProgress) {
      if (!areTermsAccepted(progress)) {
        warnings.add('Terms not accepted');
      }
    }

    // Check if account is created
    if (progress.status == OnboardingStatus.completed ||
        progress.status == OnboardingStatus.inProgress) {
      if (!isAccountCreated(progress) && progress.currentStep != OnboardingStep.accounts) {
        warnings.add('Account not created yet');
      }
    }

    // Check if current step is valid
    if (!isValidCurrentStep(progress)) {
      errors.add('Current step is invalid');
    }

    return OnboardingValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      progress: progress,
    );
  }

  /// Validate and repair progress if possible
  static OnboardingProgressModel repairProgress(
    OnboardingProgressModel progress,
  ) {
    var repaired = progress;

    // Remove invalid completed step indices
    final maxIndex = OnboardingStep.values.length - 1;
    final validSteps = repaired.completedSteps
        .where((index) => index >= 0 && index <= maxIndex)
        .toList();
    repaired = repaired.copyWith(completedSteps: validSteps);

    // Ensure current step is valid
    final currentIndex = repaired.currentStep.index;
    if (currentIndex < 0 || currentIndex > maxIndex) {
      repaired = repaired.copyWith(currentStep: OnboardingStep.welcome);
    }

    // If status is completed but not all required steps are done, downgrade status
    if (repaired.status == OnboardingStatus.completed &&
        !repaired.areAllRequiredStepsCompleted) {
      repaired = repaired.copyWith(
        status: OnboardingStatus.inProgress,
        completedAt: null,
      );
    }

    // If status is not started but has completed steps, upgrade status
    if (repaired.status == OnboardingStatus.notStarted &&
        repaired.completedSteps.isNotEmpty) {
      repaired = repaired.copyWith(status: OnboardingStatus.inProgress);
    }

    return repaired;
  }
}

/// Result model for onboarding validation
class OnboardingValidationResult {
  /// Whether the validation passed
  final bool isValid;

  /// List of validation errors
  final List<String> errors;

  /// List of validation warnings
  final List<String> warnings;

  /// The progress model that was validated
  final OnboardingProgressModel progress;

  /// Constructor
  const OnboardingValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.progress,
  });

  /// Check if there are any errors
  bool get hasErrors => errors.isNotEmpty;

  /// Check if there are any warnings
  bool get hasWarnings => warnings.isNotEmpty;

  /// Get a combined message of all errors and warnings
  String get message {
    final allMessages = <String>[];
    if (errors.isNotEmpty) {
      allMessages.add('Errors: ${errors.join(', ')}');
    }
    if (warnings.isNotEmpty) {
      allMessages.add('Warnings: ${warnings.join(', ')}');
    }
    return allMessages.join('; ');
  }

  /// Create a successful validation result
  factory OnboardingValidationResult.success(
    OnboardingProgressModel progress,
  ) {
    return OnboardingValidationResult(
      isValid: true,
      errors: const [],
      warnings: const [],
      progress: progress,
    );
  }

  /// Create a failed validation result
  factory OnboardingValidationResult.failure(
    OnboardingProgressModel progress,
    List<String> errors, {
    List<String> warnings = const [],
  }) {
    return OnboardingValidationResult(
      isValid: false,
      errors: errors,
      warnings: warnings,
      progress: progress,
    );
  }
}
