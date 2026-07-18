// lib/core/enums/notification_priority.dart

/// Enum representing the priority level of a notification.
enum NotificationPriority {
  /// Low priority - non-urgent notifications.
  low,

  /// Normal priority - standard notifications.
  normal,

  /// High priority - important notifications.
  high,

  /// Urgent priority - critical notifications requiring immediate attention.
  urgent,
}

/// Extension methods for [NotificationPriority].
extension NotificationPriorityExtension on NotificationPriority {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [NotificationPriority] from a stored string value.
  static NotificationPriority fromValue(String value) {
    return NotificationPriority.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationPriority.normal,
    );
  }

  /// Returns whether this is a high or urgent priority.
  bool get isHighPriority {
    return this == NotificationPriority.high ||
        this == NotificationPriority.urgent;
  }

  /// Returns whether this is a low or normal priority.
  bool get isLowPriority {
    return this == NotificationPriority.low ||
        this == NotificationPriority.normal;
  }

  /// Returns whether this is urgent priority.
  bool get isUrgent => this == NotificationPriority.urgent;

  /// Returns the numeric priority level (higher = more important).
  int get priorityLevel => index;
}
