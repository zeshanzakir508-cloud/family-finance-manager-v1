import '../utils/formatters.dart';

/// ============================================================================
/// Family Finance Manager
/// DateTime Extensions
/// ----------------------------------------------------------------------------
/// Common DateTime helper methods.
/// Formatting is delegated to Formatters.
/// ============================================================================

extension DateTimeExtensions on DateTime {
  //--------------------------------------------------------------------------
  // Date Checks
  //--------------------------------------------------------------------------

  bool get isToday {
    final now = DateTime.now();

    return year == now.year &&
        month == now.month &&
        day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(
      const Duration(days: 1),
    );

    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(
      const Duration(days: 1),
    );

    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  //--------------------------------------------------------------------------
  // Date Only
  //--------------------------------------------------------------------------

  DateTime get dateOnly {
    return DateTime(
      year,
      month,
      day,
    );
  }

  //--------------------------------------------------------------------------
  // Day
  //--------------------------------------------------------------------------

  DateTime get startOfDay {
    return DateTime(
      year,
      month,
      day,
    );
  }

  DateTime get endOfDay {
    return DateTime(
      year,
      month,
      day,
      23,
      59,
      59,
      999,
    );
  }

  //--------------------------------------------------------------------------
  // Month
  //--------------------------------------------------------------------------

  DateTime get startOfMonth {
    return DateTime(
      year,
      month,
      1,
    );
  }

  DateTime get endOfMonth {
    return DateTime(
      year,
      month + 1,
      0,
      23,
      59,
      59,
      999,
    );
  }

  //--------------------------------------------------------------------------
  // Year
  //--------------------------------------------------------------------------

  DateTime get startOfYear {
    return DateTime(
      year,
      1,
      1,
    );
  }

  DateTime get endOfYear {
    return DateTime(
      year,
      12,
      31,
      23,
      59,
      59,
      999,
    );
  }

  //--------------------------------------------------------------------------
  // Difference
  //--------------------------------------------------------------------------

  int daysUntil(DateTime other) {
    return other.dateOnly
        .difference(dateOnly)
        .inDays;
  }

  int daysSince(DateTime other) {
    return dateOnly
        .difference(other.dateOnly)
        .inDays;
  }

  //--------------------------------------------------------------------------
  // Formatting
  //--------------------------------------------------------------------------

  String get formattedDate {
    return Formatters.date(this);
  }

  String get formattedTime {
    return Formatters.time(this);
  }

  String get formattedDateTime {
    return Formatters.dateTime(this);
  }

  String get formattedMonthYear {
    return Formatters.monthYear(this);
  }

  String get formattedShortDate {
    return Formatters.shortDate(this);
  }
}
