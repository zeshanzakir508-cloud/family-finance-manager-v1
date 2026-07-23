import '../enums/onboarding_step.dart';
import '../enums/onboarding_status.dart';
import '../models/onboarding_progress_model.dart';

/// State class for onboarding
class OnboardingState {
  /// The current status of onboarding
  final OnboardingStatus status;

  /// The current step the user is on
  final OnboardingStep currentStep;

  /// List of completed step indices
  final List<int> completedSteps;

  /// Whether onboarding is completed
  final bool isCompleted;

  /// Whether onboarding is in progress
  final bool isInProgress;

  /// Whether onboarding has been skipped
  final bool isSkipped;

  /// Whether onboarding has not started
  final bool isNotStarted;

  /// The progress percentage (0.0 to 1.0)
  final double progress;

  /// The progress as a percentage string
  final String progressPercentage;

  /// The number of completed steps
  final int completedCount;

  /// The total number of steps
  final int totalSteps;

  /// The number of remaining steps
  final int remainingSteps;

  /// Whether all required steps are completed
  final bool allRequiredStepsCompleted;

  /// The current page model
  final OnboardingPageModel? currentPage;

  /// Whether the user can advance to the next step
  final bool canAdvance;

  /// Whether the user can go back to the previous step
  final bool canGoBack;

  /// Whether the user can skip onboarding
  final bool canSkipOnboarding;

  /// Whether the user can finish onboarding
  final bool canFinish;

  /// Error messages for the current step
  final List<String> errors;

  /// Warning messages for the current step
  final List<String> warnings;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  /// Whether the state is loading
  final bool isLoading;

  /// Whether the state has an error
  final bool hasError;

  /// The error message if any
  final String? errorMessage;

  /// Constructor
  const OnboardingState({
    this.status = OnboardingStatus.notStarted,
    this.currentStep = OnboardingStep.welcome,
    this.completedSteps = const [],
    this.isCompleted = false,
    this.isInProgress = false,
    this.isSkipped = false,
    this.isNotStarted = true,
    this.progress = 0.0,
    this.progressPercentage = '0%',
    this.completedCount = 0,
    this.totalSteps = 7,
    this.remainingSteps = 7,
    this.allRequiredStepsCompleted = false,
    this.currentPage,
    this.canAdvance = false,
    this.canGoBack = false,
    this.canSkipOnboarding = false,
    this.canFinish = false,
    this.errors = const [],
    this.warnings = const [],
    this.metadata,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });

  /// Create initial state
  factory OnboardingState.initial() {
    return const OnboardingState();
  }

  /// Create from progress model
  factory OnboardingState.fromProgress(
    OnboardingProgressModel progress, {
    bool isLoading = false,
    String? errorMessage,
    List<String> errors = const [],
    List<String> warnings = const [],
  }) {
    final currentPage = OnboardingPageModel.fromStep(progress.currentStep);
    final canAdvance = progress.currentStep != OnboardingStep.finish &&
        (progress.currentStep == OnboardingStep.welcome ||
            progress.isStepCompleted(progress.currentStep) ||
            !progress.currentStep.requiresValidation);
    final canGoBack = progress.currentStep != OnboardingStep.welcome;
    final canSkipOnboarding = progress.status == OnboardingStatus.inProgress;
    final canFinish = progress.areAllRequiredStepsCompleted &&
        progress.status != OnboardingStatus.completed;

    return OnboardingState(
      status: progress.status,
      currentStep: progress.currentStep,
      completedSteps: progress.completedSteps,
      isCompleted: progress.status == OnboardingStatus.completed,
      isInProgress: progress.status == OnboardingStatus.inProgress,
      isSkipped: progress.status == OnboardingStatus.skipped,
      isNotStarted: progress.status == OnboardingStatus.notStarted,
      progress: progress.progress,
      progressPercentage: progress.progressPercentage,
      completedCount: progress.completedCount,
      totalSteps: progress.totalSteps,
      remainingSteps: progress.remainingSteps,
      allRequiredStepsCompleted: progress.areAllRequiredStepsCompleted,
      currentPage: currentPage,
      canAdvance: canAdvance,
      canGoBack: canGoBack,
      canSkipOnboarding: canSkipOnboarding,
      canFinish: canFinish,
      errors: errors,
      warnings: warnings,
      metadata: progress.metadata,
      isLoading: isLoading,
      hasError: errorMessage != null,
      errorMessage: errorMessage,
    );
  }

  /// Create a loading state
  factory OnboardingState.loading() {
    return const OnboardingState(
      isLoading: true,
    );
  }

  /// Create an error state
  factory OnboardingState.error(String message) {
    return OnboardingState(
      hasError: true,
      errorMessage: message,
      isLoading: false,
    );
  }

  /// Copy with updated fields
  OnboardingState copyWith({
    OnboardingStatus? status,
    OnboardingStep? currentStep,
    List<int>? completedSteps,
    bool? isCompleted,
    bool? isInProgress,
    bool? isSkipped,
    bool? isNotStarted,
    double? progress,
    String? progressPercentage,
    int? completedCount,
    int? totalSteps,
    int? remainingSteps,
    bool? allRequiredStepsCompleted,
    OnboardingPageModel? currentPage,
    bool? canAdvance,
    bool? canGoBack,
    bool? canSkipOnboarding,
    bool? canFinish,
    List<String>? errors,
    List<String>? warnings,
    Map<String, dynamic>? metadata,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      completedSteps: completedSteps ?? this.completedSteps,
      isCompleted: isCompleted ?? this.isCompleted,
      isInProgress: isInProgress ?? this.isInProgress,
      isSkipped: isSkipped ?? this.isSkipped,
      isNotStarted: isNotStarted ?? this.isNotStarted,
      progress: progress ?? this.progress,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      completedCount: completedCount ?? this.completedCount,
      totalSteps: totalSteps ?? this.totalSteps,
      remainingSteps: remainingSteps ?? this.remainingSteps,
      allRequiredStepsCompleted:
          allRequiredStepsCompleted ?? this.allRequiredStepsCompleted,
      currentPage: currentPage ?? this.currentPage,
      canAdvance: canAdvance ?? this.canAdvance,
      canGoBack: canGoBack ?? this.canGoBack,
      canSkipOnboarding: canSkipOnboarding ?? this.canSkipOnboarding,
      canFinish: canFinish ?? this.canFinish,
      errors: errors ?? this.errors,
      warnings: warnings ?? this.warnings,
      metadata: metadata ?? this.metadata,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Check if there are any errors
  bool get hasErrors => errors.isNotEmpty;

  /// Check if there are any warnings
  bool get hasWarnings => warnings.isNotEmpty;

  /// Get the combined error message
  String get combinedErrorMessage {
    if (errors.isEmpty) return '';
    return errors.join('\n');
  }

  /// Get the combined warning message
  String get combinedWarningMessage {
    if (warnings.isEmpty) return '';
    return warnings.join('\n');
  }

  /// Check if the state is ready for action
  bool get isReady => !isLoading && !hasError;

  /// Get the step index
  int get stepIndex => currentStep.index;

  /// Check if the current step is the first step
  bool get isFirstStep => currentStep == OnboardingStep.welcome;

  /// Check if the current step is the last step
  bool get isLastStep => currentStep == OnboardingStep.finish;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingState &&
        other.status == status &&
        other.currentStep == currentStep &&
        other.completedSteps == completedSteps &&
        other.isCompleted == isCompleted &&
        other.isInProgress == isInProgress &&
        other.isSkipped == isSkipped &&
        other.isNotStarted == isNotStarted &&
        other.progress == progress &&
        other.progressPercentage == progressPercentage &&
        other.completedCount == completedCount &&
        other.totalSteps == totalSteps &&
        other.remainingSteps == remainingSteps &&
        other.allRequiredStepsCompleted == allRequiredStepsCompleted &&
        other.currentPage == currentPage &&
        other.canAdvance == canAdvance &&
        other.canGoBack == canGoBack &&
        other.canSkipOnboarding == canSkipOnboarding &&
        other.canFinish == canFinish &&
        other.errors == errors &&
        other.warnings == warnings &&
        other.metadata == metadata &&
        other.isLoading == isLoading &&
        other.hasError == hasError &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      currentStep,
      completedSteps,
      isCompleted,
      isInProgress,
      isSkipped,
      isNotStarted,
      progress,
      progressPercentage,
      completedCount,
      totalSteps,
      remainingSteps,
      allRequiredStepsCompleted,
      currentPage,
      canAdvance,
      canGoBack,
      canSkipOnboarding,
      canFinish,
      errors,
      warnings,
      metadata,
      isLoading,
      hasError,
      errorMessage,
    );
  }

  @override
  String toString() {
    return 'OnboardingState(status: $status, currentStep: $currentStep, '
        'progress: $progressPercentage, isLoading: $isLoading, '
        'hasError: $hasError)';
  }
}
