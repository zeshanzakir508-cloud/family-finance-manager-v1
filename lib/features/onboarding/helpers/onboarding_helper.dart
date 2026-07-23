import 'package:flutter/material.dart';
import '../enums/onboarding_step.dart';
import '../enums/onboarding_status.dart';
import '../models/onboarding_progress_model.dart';
import '../models/onboarding_page_model.dart';

/// Utility helper class for onboarding
class OnboardingHelper {
  /// Format progress as a percentage string
  static String formatProgress(double progress) {
    return '${(progress * 100).round()}%';
  }

  /// Format duration in a human-readable format
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    }
    return '${duration.inSeconds}s';
  }

  /// Get a progress message based on the current state
  static String getProgressMessage(OnboardingProgressModel progress) {
    final completed = progress.completedCount;
    final total = progress.totalSteps;
    final percentage = (completed / total * 100).round();

    if (progress.status == OnboardingStatus.completed) {
      return '🎉 Onboarding Complete!';
    }
    if (progress.status == OnboardingStatus.skipped) {
      return '⏭️ Onboarding Skipped';
    }
    if (percentage == 0) {
      return '🚀 Let\'s Get Started!';
    }
    if (percentage < 25) {
      return '🌟 Getting Started: $percentage% Complete';
    }
    if (percentage < 50) {
      return '📈 Making Progress: $percentage% Complete';
    }
    if (percentage < 75) {
      return '💪 Almost There: $percentage% Complete';
    }
    if (percentage < 100) {
      return '🎯 Nearly Done: $percentage% Complete';
    }
    return '✅ All Done!';
  }

  /// Get a motivational message based on the current step
  static String getMotivationalMessage(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.welcome:
        return 'Welcome aboard! Let\'s set up your family budget together.';
      case OnboardingStep.permissions:
        return 'Granting permissions helps us serve you better.';
      case OnboardingStep.terms:
        return 'We value your privacy. Please review our terms.';
      case OnboardingStep.family:
        return 'Family finances are better managed together!';
      case OnboardingStep.accounts:
        return 'Your financial journey starts here.';
      case OnboardingStep.categories:
        return 'Organize your expenses with categories.';
      case OnboardingStep.finish:
        return 'You\'re all set! Start managing your finances now.';
    }
  }

  /// Get a step completion message
  static String getStepCompletionMessage(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.welcome:
        return 'Welcome completed!';
      case OnboardingStep.permissions:
        return 'Permissions granted!';
      case OnboardingStep.terms:
        return 'Terms accepted!';
      case OnboardingStep.family:
        return 'Family set up!';
      case OnboardingStep.accounts:
        return 'Account created!';
      case OnboardingStep.categories:
        return 'Categories selected!';
      case OnboardingStep.finish:
        return 'Onboarding complete!';
    }
  }

  /// Get an emoji for the step
  static String getStepEmoji(OnboardingStep step) {
    return step.emoji;
  }

  /// Get a color for the step
  static Color getStepColor(OnboardingStep step) {
    return step.color;
  }

  /// Get a gradient for the step
  static List<Color> getStepGradient(OnboardingStep step) {
    return step.gradient;
  }

  /// Get an icon for the step
  static IconData getStepIcon(OnboardingStep step) {
    return step.icon;
  }

  /// Check if a step is completed
  static bool isStepCompleted(OnboardingProgressModel progress, OnboardingStep step) {
    return progress.isStepCompleted(step);
  }

  /// Get the next incomplete step
  static OnboardingStep? getNextIncompleteStep(OnboardingProgressModel progress) {
    return progress.nextIncompleteStep;
  }

  /// Calculate the estimated time to complete remaining steps
  static Duration estimateRemainingTime(OnboardingProgressModel progress) {
    const secondsPerStep = 30;
    final remaining = progress.remainingSteps;
    return Duration(seconds: remaining * secondsPerStep);
  }

  /// Format estimated remaining time
  static String formatEstimatedRemainingTime(OnboardingProgressModel progress) {
    final duration = estimateRemainingTime(progress);
    if (duration.inMinutes == 0) {
      return 'Less than a minute remaining';
    }
    if (duration.inMinutes == 1) {
      return 'About 1 minute remaining';
    }
    return 'About ${duration.inMinutes} minutes remaining';
  }

  /// Get the page title for the step
  static String getPageTitle(OnboardingStep step) {
    return step.displayName;
  }

  /// Get the page subtitle for the step
  static String getPageSubtitle(OnboardingStep step) {
    return step.description;
  }

  /// Check if the step is required
  static bool isStepRequired(OnboardingStep step) {
    return step.isRequired;
  }

  /// Check if the step can be skipped
  static bool canSkipStep(OnboardingStep step) {
    return step.canSkip;
  }

  /// Get the step by index
  static OnboardingStep getStepByIndex(int index) {
    if (index < 0 || index >= OnboardingStep.values.length) {
      return OnboardingStep.welcome;
    }
    return OnboardingStep.values[index];
  }

  /// Get the index of a step
  static int getStepIndex(OnboardingStep step) {
    return step.index;
  }

  /// Get all steps as a list
  static List<OnboardingStep> getAllSteps() {
    return OnboardingStep.values;
  }

  /// Get required steps only
  static List<OnboardingStep> getRequiredSteps() {
    return OnboardingStep.requiredSteps;
  }

  /// Get optional steps only
  static List<OnboardingStep> getOptionalSteps() {
    return OnboardingStep.optionalSteps;
  }

  /// Get skippable steps
  static List<OnboardingStep> getSkippableSteps() {
    return OnboardingStep.skippableSteps;
  }

  /// Check if the onboarding is complete
  static bool isOnboardingComplete(OnboardingProgressModel progress) {
    return progress.isComplete || progress.isSkipped;
  }

  /// Get the completion status text
  static String getCompletionStatusText(OnboardingProgressModel progress) {
    if (progress.isComplete) return 'Complete';
    if (progress.isSkipped) return 'Skipped';
    if (progress.isInProgress) return 'In Progress';
    return 'Not Started';
  }

  /// Get the completion status color
  static Color getCompletionStatusColor(OnboardingProgressModel progress) {
    if (progress.isComplete) return Colors.green;
    if (progress.isSkipped) return Colors.orange;
    if (progress.isInProgress) return Colors.blue;
    return Colors.grey;
  }

  /// Get a summary of the onboarding progress
  static String getProgressSummary(OnboardingProgressModel progress) {
    return '${progress.completedCount}/${progress.totalSteps} steps completed (${progress.progressPercentage})';
  }

  /// Check if the user is on the first step
  static bool isFirstStep(OnboardingStep step) {
    return step == OnboardingStep.welcome;
  }

  /// Check if the user is on the last step
  static bool isLastStep(OnboardingStep step) {
    return step == OnboardingStep.finish;
  }

  /// Get the previous step
  static OnboardingStep? getPreviousStep(OnboardingStep step) {
    return step.previous;
  }

  /// Get the next step
  static OnboardingStep? getNextStep(OnboardingStep step) {
    return step.next;
  }

  /// Validate step order
  static bool isValidStepOrder(List<OnboardingStep> steps) {
    if (steps.isEmpty) return false;
    
    for (var i = 0; i < steps.length - 1; i++) {
      final current = steps[i];
      final next = steps[i + 1];
      if (current.index >= next.index) {
        return false;
      }
    }
    return true;
  }

  /// Get steps between two steps
  static List<OnboardingStep> getStepsBetween(OnboardingStep start, OnboardingStep end) {
    final startIndex = start.index;
    final endIndex = end.index;
    final steps = <OnboardingStep>[];
    
    final minIndex = startIndex < endIndex ? startIndex : endIndex;
    final maxIndex = startIndex < endIndex ? endIndex : startIndex;
    
    for (var i = minIndex; i <= maxIndex; i++) {
      steps.add(OnboardingStep.values[i]);
    }
    return steps;
  }

  /// Check if a step is after another step
  static bool isStepAfter(OnboardingStep step, OnboardingStep after) {
    return step.index > after.index;
  }

  /// Check if a step is before another step
  static bool isStepBefore(OnboardingStep step, OnboardingStep before) {
    return step.index < before.index;
  }

  /// Get the status message for analytics
  static String getStatusMessage(OnboardingStatus status) {
    switch (status) {
      case OnboardingStatus.notStarted:
        return 'user_viewed_onboarding_start';
      case OnboardingStatus.inProgress:
        return 'user_continued_onboarding';
      case OnboardingStatus.completed:
        return 'user_completed_onboarding';
      case OnboardingStatus.skipped:
        return 'user_skipped_onboarding';
    }
  }

  /// Get the step name for analytics
  static String getStepAnalyticsName(OnboardingStep step) {
    return 'onboarding_step_${step.name}';
  }

  /// Generate a unique session ID for onboarding
  static String generateSessionId() {
    return 'onboarding_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  /// Check if onboarding should be shown
  static bool shouldShowOnboarding(bool isFirstLaunch, bool isCompleted) {
    return isFirstLaunch && !isCompleted;
  }

  /// Get the appropriate route based on onboarding status
  static String getRedirectRoute(OnboardingProgressModel progress) {
    if (progress.isComplete || progress.isSkipped) {
      return '/dashboard';
    }
    return '/onboarding';
  }

  /// Get the step to redirect to based on progress
  static OnboardingStep getRedirectStep(OnboardingProgressModel progress) {
    if (progress.isComplete || progress.isSkipped) {
      return OnboardingStep.finish;
    }
    return progress.currentStep;
  }

  /// Check if the onboarding data is stale
  static bool isStale(OnboardingProgressModel progress) {
    if (progress.status != OnboardingStatus.inProgress) return false;
    
    final elapsed = progress.timeElapsed;
    if (elapsed == null) return false;
    
    return elapsed > const Duration(minutes: 10);
  }

  /// Get a friendly time since last update
  static String getTimeSinceLastUpdate(DateTime? lastUpdated) {
    if (lastUpdated == null) return 'Never';
    
    final difference = DateTime.now().difference(lastUpdated);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    }
    if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    }
    if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }
    return 'Just now';
  }

  /// Check if onboarding is in a terminal state
  static bool isTerminalState(OnboardingStatus status) {
    return status == OnboardingStatus.completed || status == OnboardingStatus.skipped;
  }

  /// Get the next actionable status
  static OnboardingStatus getNextStatus(OnboardingStatus current) {
    switch (current) {
      case OnboardingStatus.notStarted:
        return OnboardingStatus.inProgress;
      case OnboardingStatus.inProgress:
        return OnboardingStatus.completed;
      case OnboardingStatus.completed:
        return OnboardingStatus.completed;
      case OnboardingStatus.skipped:
        return OnboardingStatus.skipped;
    }
  }
}
