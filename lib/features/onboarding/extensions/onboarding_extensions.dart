import 'package:flutter/material.dart';
import '../enums/onboarding_step.dart';
import '../enums/onboarding_status.dart';
import '../models/onboarding_progress_model.dart';
import '../models/onboarding_page_model.dart';

/// Extension methods for OnboardingStep
extension OnboardingStepUIExtensions on OnboardingStep {
  /// Get the color for the step
  Color get color {
    switch (this) {
      case OnboardingStep.welcome:
        return Colors.blue;
      case OnboardingStep.permissions:
        return Colors.purple;
      case OnboardingStep.terms:
        return Colors.orange;
      case OnboardingStep.family:
        return Colors.green;
      case OnboardingStep.accounts:
        return Colors.teal;
      case OnboardingStep.categories:
        return Colors.pink;
      case OnboardingStep.finish:
        return Colors.green;
    }
  }

  /// Get the lighter color for the step (for backgrounds)
  Color get lightColor {
    return color.withOpacity(0.1);
  }

  /// Get the darker color for the step (for text)
  Color get darkColor {
    return color.withOpacity(0.8);
  }

  /// Get the icon for the step
  IconData get icon {
    switch (this) {
      case OnboardingStep.welcome:
        return Icons.waving_hand;
      case OnboardingStep.permissions:
        return Icons.security;
      case OnboardingStep.terms:
        return Icons.description;
      case OnboardingStep.family:
        return Icons.family_restroom;
      case OnboardingStep.accounts:
        return Icons.account_balance_wallet;
      case OnboardingStep.categories:
        return Icons.category;
      case OnboardingStep.finish:
        return Icons.celebration;
    }
  }

  /// Get the emoji for the step
  String get emoji {
    switch (this) {
      case OnboardingStep.welcome:
        return '👋';
      case OnboardingStep.permissions:
        return '🔒';
      case OnboardingStep.terms:
        return '📋';
      case OnboardingStep.family:
        return '👨‍👩‍👧‍👦';
      case OnboardingStep.accounts:
        return '💳';
      case OnboardingStep.categories:
        return '🏷️';
      case OnboardingStep.finish:
        return '🎉';
    }
  }

  /// Get the gradient for the step
  List<Color> get gradient {
    switch (this) {
      case OnboardingStep.welcome:
        return [Colors.blue.shade400, Colors.blue.shade700];
      case OnboardingStep.permissions:
        return [Colors.purple.shade400, Colors.purple.shade700];
      case OnboardingStep.terms:
        return [Colors.orange.shade400, Colors.orange.shade700];
      case OnboardingStep.family:
        return [Colors.green.shade400, Colors.green.shade700];
      case OnboardingStep.accounts:
        return [Colors.teal.shade400, Colors.teal.shade700];
      case OnboardingStep.categories:
        return [Colors.pink.shade400, Colors.pink.shade700];
      case OnboardingStep.finish:
        return [Colors.green.shade400, Colors.green.shade700];
    }
  }

  /// Get the secondary gradient for the step (lighter)
  List<Color> get lightGradient {
    switch (this) {
      case OnboardingStep.welcome:
        return [Colors.blue.shade100, Colors.blue.shade300];
      case OnboardingStep.permissions:
        return [Colors.purple.shade100, Colors.purple.shade300];
      case OnboardingStep.terms:
        return [Colors.orange.shade100, Colors.orange.shade300];
      case OnboardingStep.family:
        return [Colors.green.shade100, Colors.green.shade300];
      case OnboardingStep.accounts:
        return [Colors.teal.shade100, Colors.teal.shade300];
      case OnboardingStep.categories:
        return [Colors.pink.shade100, Colors.pink.shade300];
      case OnboardingStep.finish:
        return [Colors.green.shade100, Colors.green.shade300];
    }
  }

  /// Get the accessibility label for the step
  String get accessibilityLabel {
    return 'Step ${index + 1} of ${OnboardingStep.values.length}: $displayName';
  }
}

/// Extension methods for OnboardingStatus
extension OnboardingStatusUIExtensions on OnboardingStatus {
  /// Get the color for the status
  Color get color {
    switch (this) {
      case OnboardingStatus.notStarted:
        return Colors.grey;
      case OnboardingStatus.inProgress:
        return Colors.blue;
      case OnboardingStatus.completed:
        return Colors.green;
      case OnboardingStatus.skipped:
        return Colors.orange;
    }
  }

  /// Get the icon for the status
  IconData get icon {
    switch (this) {
      case OnboardingStatus.notStarted:
        return Icons.circle_outlined;
      case OnboardingStatus.inProgress:
        return Icons.timelapse;
      case OnboardingStatus.completed:
        return Icons.check_circle;
      case OnboardingStatus.skipped:
        return Icons.skip_next;
    }
  }

  /// Get the status badge label
  String get badgeLabel {
    switch (this) {
      case OnboardingStatus.notStarted:
        return 'New';
      case OnboardingStatus.inProgress:
        return 'In Progress';
      case OnboardingStatus.completed:
        return 'Complete';
      case OnboardingStatus.skipped:
        return 'Skipped';
    }
  }

  /// Get the status description for accessibility
  String get accessibilityDescription {
    return 'Onboarding status: $displayName. $message';
  }
}

/// Extension methods for OnboardingProgressModel
extension OnboardingProgressUIExtensions on OnboardingProgressModel {
  /// Get the progress as a double between 0 and 1
  double get progressValue {
    return progress;
  }

  /// Get the progress as a percentage (0-100)
  int get progressPercentageValue {
    return (progress * 100).round();
  }

  /// Get the progress bar value (0-1)
  double get progressBarValue {
    // For progress bar, we want to show the current step progress
    // Not just completed steps, but also current step progress
    final totalSteps = OnboardingStep.values.length;
    final currentIndex = currentStep.index;
    final completedCount = completedSteps.length;
    
    // If we're on the last step and it's not completed, show full progress
    if (currentStep == OnboardingStep.finish && !isStepCompleted(OnboardingStep.finish)) {
      return (completedCount + 0.5) / totalSteps;
    }
    
    // If the current step is completed, count it as complete
    if (isStepCompleted(currentStep)) {
      return completedCount / totalSteps;
    }
    
    // Otherwise, count completed steps and partial for current step
    return (completedCount + 0.5) / totalSteps;
  }

  /// Get the step index as a percentage (0-100)
  int get stepIndexPercentage {
    final totalSteps = OnboardingStep.values.length;
    final currentIndex = currentStep.index;
    return ((currentIndex + 1) / totalSteps * 100).round();
  }

  /// Check if the progress is at the beginning
  bool get isAtBeginning {
    return currentStep == OnboardingStep.welcome;
  }

  /// Check if the progress is at the end
  bool get isAtEnd {
    return currentStep == OnboardingStep.finish;
  }

  /// Get the current page model
  OnboardingPageModel get currentPageModel {
    return OnboardingPageModel.fromStep(currentStep);
  }

  /// Get all page models
  List<OnboardingPageModel> getAllPageModels() {
    return OnboardingPageModel.getAllPages();
  }

  /// Get the next step if available
  OnboardingStep? get nextStep {
    return currentStep.next;
  }

  /// Get the previous step if available
  OnboardingStep? get previousStep {
    return currentStep.previous;
  }

  /// Get the percentage of required steps completed
  double get requiredProgress {
    final requiredSteps = OnboardingStep.requiredSteps;
    if (requiredSteps.isEmpty) return 1.0;
    
    final completedRequired = requiredSteps
        .where((step) => isStepCompleted(step))
        .length;
    
    return completedRequired / requiredSteps.length;
  }

  /// Get the percentage of required steps completed as a percentage (0-100)
  int get requiredProgressPercentage {
    return (requiredProgress * 100).round();
  }

  /// Check if all required steps are completed
  bool get hasCompletedAllRequiredSteps {
    return areAllRequiredStepsCompleted;
  }

  /// Get the status message for the current state
  String get statusMessage {
    if (status == OnboardingStatus.completed) {
      return '🎉 Onboarding complete!';
    }
    if (status == OnboardingStatus.skipped) {
      return '⏭️ Onboarding skipped';
    }
    if (status == OnboardingStatus.notStarted) {
      return '🚀 Ready to start';
    }
    
    // In progress
    final remaining = remainingRequiredSteps.length;
    if (remaining == 0) {
      return '✅ All required steps complete!';
    }
    return '📝 $remaining step${remaining > 1 ? 's' : ''} remaining';
  }

  /// Check if the current step is the first incomplete step
  bool get isFirstIncompleteStep {
    if (isStepCompleted(currentStep)) return false;
    
    final previousSteps = OnboardingStep.values
        .where((step) => step.isBefore(currentStep))
        .toList();
    
    return previousSteps.every((step) => isStepCompleted(step));
  }

  /// Get the next incomplete step
  OnboardingStep? get nextIncompleteStep {
    return incompleteStepList.firstOrNull;
  }

  /// Get the previous incomplete step
  OnboardingStep? get previousIncompleteStep {
    final incomplete = incompleteStepList;
    if (incomplete.isEmpty) return null;
    
    final currentIndex = incomplete.indexOf(currentStep);
    if (currentIndex <= 0) return null;
    
    return incomplete[currentIndex - 1];
  }

  /// Get the steps that are ready to be completed (previous steps are done)
  List<OnboardingStep> get readySteps {
    final ready = <OnboardingStep>[];
    for (var i = 0; i < OnboardingStep.values.length; i++) {
      final step = OnboardingStep.values[i];
      if (isStepCompleted(step)) continue;
      
      final previousSteps = OnboardingStep.values
          .where((s) => s.isBefore(step))
          .toList();
      
      if (previousSteps.every((s) => isStepCompleted(s))) {
        ready.add(step);
      }
    }
    return ready;
  }

  /// Get the time since onboarding started
  Duration? get timeElapsed {
    if (startedAt == null) return null;
    return DateTime.now().difference(startedAt!);
  }

  /// Get the time since onboarding was completed
  Duration? get timeSinceCompletion {
    if (completedAt == null) return null;
    return DateTime.now().difference(completedAt!);
  }

  /// Format the time elapsed
  String get formattedTimeElapsed {
    final elapsed = timeElapsed;
    if (elapsed == null) return 'Not started';
    
    if (elapsed.inDays > 0) {
      return '${elapsed.inDays}d ${elapsed.inHours % 24}h';
    }
    if (elapsed.inHours > 0) {
      return '${elapsed.inHours}h ${elapsed.inMinutes % 60}m';
    }
    if (elapsed.inMinutes > 0) {
      return '${elapsed.inMinutes}m ${elapsed.inSeconds % 60}s';
    }
    return '${elapsed.inSeconds}s';
  }

  /// Get the estimated time remaining
  String get estimatedTimeRemainingFormatted {
    final minutes = estimatedTimeRemaining;
    if (minutes <= 0) return 'Almost done!';
    if (minutes == 1) return '1 minute remaining';
    return '$minutes minutes remaining';
  }

  /// Check if the onboarding is taking too long
  bool get isTakingTooLong {
    final elapsed = timeElapsed;
    if (elapsed == null) return false;
    return elapsed > const Duration(minutes: 10);
  }
}

/// Extension methods for List<OnboardingStep>
extension OnboardingStepListExtensions on List<OnboardingStep> {
  /// Get the display names of all steps
  List<String> get displayNames {
    return map((step) => step.displayName).toList();
  }

  /// Get the short display names of all steps
  List<String> get shortDisplayNames {
    return map((step) => step.shortDisplayName).toList();
  }

  /// Get the indices of all steps
  List<int> get indices {
    return map((step) => step.index).toList();
  }

  /// Join the step names with a separator
  String joinNames([String separator = ' → ']) {
    return displayNames.join(separator);
  }

  /// Check if the list contains a step by index
  bool containsIndex(int index) {
    return any((step) => step.index == index);
  }

  /// Get a subset of steps within a range
  List<OnboardingStep> sublistRange(int start, int end) {
    if (start < 0) start = 0;
    if (end > length) end = length;
    if (start >= end) return [];
    return sublist(start, end);
  }

  /// Get the steps between two steps (inclusive)
  List<OnboardingStep> stepsBetween(
    OnboardingStep start,
    OnboardingStep end,
  ) {
    final startIndex = start.index;
    final endIndex = end.index;
    final startPos = startIndex < endIndex ? startIndex : endIndex;
    final endPos = startIndex < endIndex ? endIndex : startIndex;
    return sublistRange(startPos, endPos + 1);
  }

  /// Check if the list has a specific step
  bool hasStep(OnboardingStep step) {
    return contains(step);
  }

  /// Get the next step after a given step
  OnboardingStep? stepAfter(OnboardingStep step) {
    final index = step.index + 1;
    if (index >= length) return null;
    return this[index];
  }

  /// Get the previous step before a given step
  OnboardingStep? stepBefore(OnboardingStep step) {
    final index = step.index - 1;
    if (index < 0) return null;
    return this[index];
  }
}

/// Extension methods for nullable OnboardingProgressModel
extension NullableOnboardingProgressExtensions on OnboardingProgressModel? {
  /// Check if progress is not null and completed
  bool get isCompleted {
    return this?.status == OnboardingStatus.completed;
  }

  /// Check if progress is not null and in progress
  bool get isInProgress {
    return this?.status == OnboardingStatus.inProgress;
  }

  /// Check if progress is not null and not started
  bool get isNotStarted {
    return this?.status == OnboardingStatus.notStarted;
  }

  /// Check if progress is not null and skipped
  bool get isSkipped {
    return this?.status == OnboardingStatus.skipped;
  }

  /// Get the progress or a default value
  OnboardingProgressModel get orDefault {
    return this ?? OnboardingProgressModel.initial();
  }

  /// Get the status or a default status
  OnboardingStatus get statusOrDefault {
    return this?.status ?? OnboardingStatus.notStarted;
  }

  /// Get the current step or a default step
  OnboardingStep get currentStepOrDefault {
    return this?.currentStep ?? OnboardingStep.welcome;
  }

  /// Get the progress percentage or 0
  int get progressPercentageOrDefault {
    return this?.progressPercentageValue ?? 0;
  }

  /// Check if the progress exists
  bool get exists {
    return this != null;
  }
}
