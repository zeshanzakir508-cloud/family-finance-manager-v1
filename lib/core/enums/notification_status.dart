// lib/core/enums/notification_status.dart

/// Enum representing the status of a notification or related entity.
enum NotificationStatus {
  /// Entity is pending.
  pending,

  /// Entity is completed.
  completed,

  /// Entity has failed.
  failed,

  /// Entity is in progress.
  inProgress,

  /// Entity has been cancelled.
  cancelled,

  /// Entity has been acknowledged.
  acknowledged,
}

/// Extension methods for [NotificationStatus].
extension NotificationStatusExtension on NotificationStatus {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [NotificationStatus] from a stored string value.
  static NotificationStatus fromValue(String value) {
    return NotificationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationStatus.pending,
    );
  }

  /// Returns whether this is a terminal state (no further changes expected).
  bool get isTerminal {
    return this == NotificationStatus.completed ||
        this == NotificationStatus.failed ||
        this == NotificationStatus.cancelled;
  }

  /// Returns whether this is an active state (still in progress).
  bool get isActive {
    return this == NotificationStatus.pending ||
        this == NotificationStatus.inProgress ||
        this == NotificationStatus.acknowledged;
  }

  /// Returns whether this is a successful state.
  bool get isSuccessful {
    return this == NotificationStatus.completed ||
        this == NotificationStatus.acknowledged;
  }

  /// Returns whether this is a failure state.
  bool get isFailure {
    return this == NotificationStatus.failed ||
        this == NotificationStatus.cancelled;
  }

  /// Returns whether this is a pending state.
  bool get isPending => this == NotificationStatus.pending;

  /// Returns whether this is in progress.
  bool get isInProgress => this == NotificationStatus.inProgress;
}
