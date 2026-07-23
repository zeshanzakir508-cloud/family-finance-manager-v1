import 'package:flutter/material.dart';
import '../enums/onboarding_step.dart';
import '../enums/onboarding_status.dart';

/// Model representing the progress of the onboarding process
class OnboardingProgressModel {
  /// The current status of onboarding
  final OnboardingStatus status;

  /// The current step the user is on
  final OnboardingStep currentStep;

  /// List of completed step indices
  final List<int> completedSteps;

  /// Timestamp when the onboarding was completed
  final DateTime? completedAt;

  /// Timestamp when the onboarding was started
  final DateTime? startedAt;

  /// Timestamp of the last update
  final DateTime? lastUpdatedAt;

  /// Version of the onboarding
  final String version;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  /// Constructor
  const OnboardingProgressModel({
    this.status = OnboardingStatus.notStarted,
    this.currentStep = OnboardingStep.welcome,
    this.completedSteps = const [],
    this.completedAt,
    this.startedAt,
    this.lastUpdatedAt,
    this.version = '1.0.0',
    this.metadata,
  });

  /// Create an empty/initial progress model
  factory OnboardingProgressModel.initial() {
    return const OnboardingProgressModel(
      status: OnboardingStatus.notStarted,
      currentStep: OnboardingStep.welcome,
      completedSteps: [],
      version: '1.0.0',
    );
  }

  /// Create from JSON
  factory OnboardingProgressModel.fromJson(Map<String, dynamic> json) {
    return OnboardingProgressModel(
      status: OnboardingStatusExtension.fromString(
        json['status'] ?? 'notStarted',
      ),
      currentStep: OnboardingStepExtension.fromString(
        json['currentStep'] ?? 'welcome',
      ),
      completedSteps: List<int>.from(json['completedSteps'] ?? []),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'])
          : null,
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'])
          : null,
      version: json['version'] ?? '1.0.0',
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'currentStep': currentStep.name,
      'completedSteps': completedSteps,
      'completedAt': completedAt?.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
      'version': version,
      'metadata': metadata,
    };
  }

  /// Mark a step as completed
  OnboardingProgressModel markStepCompleted(OnboardingStep step) {
    final index = step.index;
    if (!completedSteps.contains(index)) {
      final newCompletedSteps = List<int>.from(completedSteps)..add(index);
      return copyWith(
        completedSteps: newCompletedSteps,
        lastUpdatedAt: DateTime.now(),
      );
    }
    return this;
  }

  /// Mark a step as not completed
  OnboardingProgressModel markStepIncomplete(OnboardingStep step) {
    final index = step.index;
    if (completedSteps.contains(index)) {
      final newCompletedSteps = List<int>.from(completedSteps)..remove(index);
      return copyWith(
        completedSteps: newCompletedSteps,
        lastUpdatedAt: DateTime.now(),
      );
    }
    return this;
  }

  /// Check if a step is completed
  bool isStepCompleted(OnboardingStep step) {
    return completedSteps.contains(step.index);
  }

  /// Get the progress percentage (0.0 to 1.0)
  double get progress {
    final totalSteps = OnboardingStep.values.length;
    final completedCount = completedSteps.length;
    if (totalSteps == 0) return 0.0;
    return completedCount / totalSteps;
  }

  /// Get the progress as a percentage string
  String get progressPercentage {
    return '${(progress * 100).round()}%';
  }

  /// Get the number of completed steps
  int get completedCount => completedSteps.length;

  /// Get the total number of steps
  int get totalSteps => OnboardingStep.values.length;

  /// Get the remaining steps
  int get remainingSteps => totalSteps - completedCount;

  /// Check if the onboarding is complete
  bool get isComplete => status == OnboardingStatus.completed;

  /// Check if the onboarding is in progress
  bool get isInProgress => status == OnboardingStatus.inProgress;

  /// Check if all required steps are completed
  bool get areAllRequiredStepsCompleted {
    final requiredSteps = OnboardingStep.requiredSteps;
    return requiredSteps.every((step) => isStepCompleted(step));
  }

  /// Get list of completed step enums
  List<OnboardingStep> get completedStepList {
    return completedSteps
        .where((index) => index >= 0 && index < OnboardingStep.values.length)
        .map((index) => OnboardingStep.values[index])
        .toList();
  }

  /// Get list of incomplete step enums
  List<OnboardingStep> get incompleteStepList {
    return OnboardingStep.values
        .where((step) => !isStepCompleted(step))
        .toList();
  }

  /// Get list of remaining required steps
  List<OnboardingStep> get remainingRequiredSteps {
    return OnboardingStep.requiredSteps
        .where((step) => !isStepCompleted(step))
        .toList();
  }

  /// Check if the current step is the first step
  bool get isFirstStep => currentStep == OnboardingStep.welcome;

  /// Check if the current step is the last step
  bool get isLastStep => currentStep == OnboardingStep.finish;

  /// Calculate estimated time remaining (in minutes)
  int get estimatedTimeRemaining {
    // Assuming 30 seconds per step
    const secondsPerStep = 30;
    return remainingSteps * secondsPerStep ~/ 60;
  }

  /// Create a copy with updated fields
  OnboardingProgressModel copyWith({
    OnboardingStatus? status,
    OnboardingStep? currentStep,
    List<int>? completedSteps,
    DateTime? completedAt,
    DateTime? startedAt,
    DateTime? lastUpdatedAt,
    String? version,
    Map<String, dynamic>? metadata,
  }) {
    return OnboardingProgressModel(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      completedSteps: completedSteps ?? this.completedSteps,
      completedAt: completedAt ?? this.completedAt,
      startedAt: startedAt ?? this.startedAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      version: version ?? this.version,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Mark onboarding as started
  OnboardingProgressModel markStarted() {
    return copyWith(
      status: OnboardingStatus.inProgress,
      startedAt: startedAt ?? DateTime.now(),
      lastUpdatedAt: DateTime.now(),
    );
  }

  /// Mark onboarding as completed
  OnboardingProgressModel markCompleted() {
    return copyWith(
      status: OnboardingStatus.completed,
      completedAt: DateTime.now(),
      lastUpdatedAt: DateTime.now(),
    );
  }

  /// Mark onboarding as skipped
  OnboardingProgressModel markSkipped() {
    return copyWith(
      status: OnboardingStatus.skipped,
      completedAt: DateTime.now(),
      lastUpdatedAt: DateTime.now(),
    );
  }

  /// Reset the progress
  OnboardingProgressModel reset() {
    return const OnboardingProgressModel.initial();
  }

  /// Move to the next step
  OnboardingProgressModel goToNextStep() {
    final next = currentStep.next;
    if (next != null) {
      return copyWith(
        currentStep: next,
        lastUpdatedAt: DateTime.now(),
      );
    }
    return this;
  }

  /// Move to the previous step
  OnboardingProgressModel goToPreviousStep() {
    final previous = currentStep.previous;
    if (previous != null) {
      return copyWith(
        currentStep: previous,
        lastUpdatedAt: DateTime.now(),
      );
    }
    return this;
  }

  /// Go to a specific step
  OnboardingProgressModel goToStep(OnboardingStep step) {
    return copyWith(
      currentStep: step,
      lastUpdatedAt: DateTime.now(),
    );
  }

  /// Check if the progress model is valid
  bool get isValid {
    return status != OnboardingStatus.notStarted ||
        completedSteps.isNotEmpty ||
        currentStep != OnboardingStep.welcome;
  }

  @override
  String toString() {
    return 'OnboardingProgressModel(status: $status, currentStep: $currentStep, progress: $progressPercentage, completedSteps: $completedCount/$totalSteps)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingProgressModel &&
        other.status == status &&
        other.currentStep == currentStep &&
        other.completedSteps == completedSteps &&
        other.completedAt == completedAt &&
        other.startedAt == startedAt &&
        other.lastUpdatedAt == lastUpdatedAt &&
        other.version == version &&
        other.metadata == metadata;
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      currentStep,
      completedSteps,
      completedAt,
      startedAt,
      lastUpdatedAt,
      version,
      metadata,
    );
  }
}
