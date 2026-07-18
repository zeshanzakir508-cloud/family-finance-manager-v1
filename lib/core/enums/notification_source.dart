// lib/core/enums/notification_source.dart

/// Enum representing the source of a notification.
enum NotificationSource {
  /// System-generated notification.
  system,

  /// Transaction-related notification.
  transaction,

  /// Budget-related notification.
  budget,

  /// Family-related notification.
  family,

  /// Security-related notification.
  security,

  /// Promotion-related notification.
  promotion,

  /// User-generated notification.
  user,
}

/// Extension methods for [NotificationSource].
extension NotificationSourceExtension on NotificationSource {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [NotificationSource] from a stored string value.
  static NotificationSource fromValue(String value) {
    return NotificationSource.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationSource.system,
    );
  }

  /// Returns whether this is a financial source (transaction or budget).
  bool get isFinancialSource {
    return this == NotificationSource.transaction ||
        this == NotificationSource.budget;
  }
}
