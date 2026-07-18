// lib/core/enums/recurring_type.dart

/// Enum representing recurring transaction types.
enum RecurringType {
  /// Daily recurrence.
  daily,

  /// Weekly recurrence.
  weekly,

  /// Monthly recurrence.
  monthly,

  /// Yearly recurrence.
  yearly,
}

/// Extension methods for [RecurringType].
extension RecurringTypeExtension on RecurringType {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [RecurringType] from a stored string value.
  static RecurringType fromValue(String value) {
    return RecurringType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => RecurringType.monthly,
    );
  }
}
