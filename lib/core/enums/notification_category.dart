// lib/core/enums/notification_category.dart

/// Enum representing the category of a notification.
enum NotificationCategory {
  /// General notifications.
  general,

  /// Financial notifications.
  financial,

  /// Social/family notifications.
  social,

  /// Security notifications.
  security,

  /// System notifications.
  system,

  /// Promotional notifications.
  promotional,

  /// Reminder notifications.
  reminder,
}

/// Extension methods for [NotificationCategory].
extension NotificationCategoryExtension on NotificationCategory {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [NotificationCategory] from a stored string value.
  static NotificationCategory fromValue(String value) {
    return NotificationCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationCategory.general,
    );
  }

  /// Returns whether this is a financial category.
  bool get isFinancialCategory => this == NotificationCategory.financial;

  /// Returns whether this is a system category.
  bool get isSystemCategory {
    return this == NotificationCategory.system ||
        this == NotificationCategory.security;
  }

  /// Returns whether this is a social category.
  bool get isSocialCategory => this == NotificationCategory.social;

  /// Returns whether this is a marketing category.
  bool get isMarketingCategory => this == NotificationCategory.promotional;
}
