// lib/core/enums/weekday.dart

/// Enum representing days of the week.
enum Weekday {
  /// Monday.
  monday,

  /// Tuesday.
  tuesday,

  /// Wednesday.
  wednesday,

  /// Thursday.
  thursday,

  /// Friday.
  friday,

  /// Saturday.
  saturday,

  /// Sunday.
  sunday,
}

/// Extension methods for [Weekday].
extension WeekdayExtension on Weekday {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [Weekday] from a stored string value.
  static Weekday fromValue(String value) {
    return Weekday.values.firstWhere(
      (e) => e.name == value,
      orElse: () => Weekday.monday,
    );
  }

  /// Returns whether this is a weekend day (Saturday or Sunday).
  bool get isWeekend {
    return this == Weekday.saturday || this == Weekday.sunday;
  }

  /// Returns whether this is a weekday (Monday to Friday).
  bool get isWeekday {
    return !isWeekend;
  }

  /// Returns the numeric representation (1 = Monday, 7 = Sunday).
  int get numericValue {
    return index + 1;
  }
}
