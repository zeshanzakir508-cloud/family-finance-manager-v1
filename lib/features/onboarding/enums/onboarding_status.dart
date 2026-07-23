/// Enum representing the status of the onboarding process
enum OnboardingStatus {
  notStarted,
  inProgress,
  completed,
  skipped,
}

/// Extension methods for OnboardingStatus
extension OnboardingStatusExtension on OnboardingStatus {
  /// Get the display name for the status
  String get displayName {
    switch (this) {
      case OnboardingStatus.notStarted:
        return 'Not Started';
      case OnboardingStatus.inProgress:
        return 'In Progress';
      case OnboardingStatus.completed:
        return 'Completed';
      case OnboardingStatus.skipped:
        return 'Skipped';
    }
  }

  /// Get the short display name for the status
  String get shortDisplayName {
    switch (this) {
      case OnboardingStatus.notStarted:
        return 'New';
      case OnboardingStatus.inProgress:
        return 'Ongoing';
      case OnboardingStatus.completed:
        return 'Done';
      case OnboardingStatus.skipped:
        return 'Skipped';
    }
  }

  /// Check if the onboarding is completed
  bool get isCompleted {
    return this == OnboardingStatus.completed;
  }

  /// Check if the onboarding is in progress
  bool get isInProgress {
    return this == OnboardingStatus.inProgress;
  }

  /// Check if the onboarding has not started
  bool get isNotStarted {
    return this == OnboardingStatus.notStarted;
  }

  /// Check if the onboarding was skipped
  bool get isSkipped {
    return this == OnboardingStatus.skipped;
  }

  /// Check if the user can proceed from this status
  bool get canProceed {
    switch (this) {
      case OnboardingStatus.notStarted:
        return true;
      case OnboardingStatus.inProgress:
        return true;
      case OnboardingStatus.completed:
        return false;
      case OnboardingStatus.skipped:
        return false;
    }
  }

  /// Get the status from string value
  static OnboardingStatus fromString(String value) {
    return values.firstWhere(
      (status) => status.name == value,
      orElse: () => OnboardingStatus.notStarted,
    );
  }

  /// Get the next status
  OnboardingStatus get next {
    switch (this) {
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

  /// Get the priority of the status (higher = more progressed)
  int get priority {
    switch (this) {
      case OnboardingStatus.notStarted:
        return 0;
      case OnboardingStatus.inProgress:
        return 1;
      case OnboardingStatus.completed:
        return 2;
      case OnboardingStatus.skipped:
        return 3;
    }
  }

  /// Check if this status has higher priority than another
  bool isHigherPriorityThan(OnboardingStatus other) {
    return priority > other.priority;
  }

  /// Check if this status has lower priority than another
  bool isLowerPriorityThan(OnboardingStatus other) {
    return priority < other.priority;
  }

  /// Get color for the status (for UI indicators)
  String get colorHex {
    switch (this) {
      case OnboardingStatus.notStarted:
        return '#9E9E9E'; // Grey
      case OnboardingStatus.inProgress:
        return '#2196F3'; // Blue
      case OnboardingStatus.completed:
        return '#4CAF50'; // Green
      case OnboardingStatus.skipped:
        return '#FF9800'; // Orange
    }
  }

  /// Get icon name for the status
  String get iconName {
    switch (this) {
      case OnboardingStatus.notStarted:
        return 'circle';
      case OnboardingStatus.inProgress:
        return 'progress_loading';
      case OnboardingStatus.completed:
        return 'check_circle';
      case OnboardingStatus.skipped:
        return 'skip_circle';
    }
  }

  /// Get the status message
  String get message {
    switch (this) {
      case OnboardingStatus.notStarted:
        return 'Ready to begin onboarding';
      case OnboardingStatus.inProgress:
        return 'Onboarding in progress';
      case OnboardingStatus.completed:
        return 'Onboarding completed successfully';
      case OnboardingStatus.skipped:
        return 'Onboarding was skipped';
    }
  }

  /// Check if the status represents a terminal state
  bool get isTerminal {
    switch (this) {
      case OnboardingStatus.completed:
        return true;
      case OnboardingStatus.skipped:
        return true;
      default:
        return false;
    }
  }

  /// Check if the status represents an actionable state
  bool get isActionable {
    switch (this) {
      case OnboardingStatus.notStarted:
        return true;
      case OnboardingStatus.inProgress:
        return true;
      default:
        return false;
    }
  }

  /// Get all statuses
  static List<OnboardingStatus> get allStatuses => values;

  /// Get only terminal statuses
  static List<OnboardingStatus> get terminalStatuses =>
      values.where((status) => status.isTerminal).toList();

  /// Get only actionable statuses
  static List<OnboardingStatus> get actionableStatuses =>
      values.where((status) => status.isActionable).toList();

  /// Parse status from boolean (for backward compatibility)
  static OnboardingStatus fromBool(bool completed) {
    return completed ? OnboardingStatus.completed : OnboardingStatus.notStarted;
  }

  /// Convert status to boolean (for backward compatibility)
  bool toBool() {
    return this == OnboardingStatus.completed;
  }
}
