/// Defines supported notification types.
enum NotificationType {
  system,
  family,
  transaction,
  reminder,
}

extension NotificationTypeExtension on NotificationType {
  String get value => name;

  bool get isSystem => this == NotificationType.system;

  bool get isFamily => this == NotificationType.family;

  bool get isTransaction => this == NotificationType.transaction;

  bool get isReminder => this == NotificationType.reminder;

  static NotificationType fromValue(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => NotificationType.system,
    );
  }
}
