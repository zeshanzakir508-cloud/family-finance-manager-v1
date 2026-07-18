// lib/core/enums/notification_entity_type.dart

/// Enum representing the type of entity referenced in a notification.
enum NotificationEntityType {
  /// Transaction entity.
  transaction,

  /// Account entity.
  account,

  /// Category entity.
  category,

  /// Family entity.
  family,

  /// Budget entity.
  budget,
}

/// Extension methods for [NotificationEntityType].
extension NotificationEntityTypeExtension on NotificationEntityType {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [NotificationEntityType] from a stored string value.
  static NotificationEntityType fromValue(String value) {
    return NotificationEntityType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationEntityType.transaction,
    );
  }

  /// Returns whether this is a financial entity (transaction, account, category, budget).
  bool get isFinancialEntity {
    return this == NotificationEntityType.transaction ||
        this == NotificationEntityType.account ||
        this == NotificationEntityType.category ||
        this == NotificationEntityType.budget;
  }

  /// Returns whether this is a social entity (family).
  bool get isSocialEntity {
    return this == NotificationEntityType.family;
  }
}
