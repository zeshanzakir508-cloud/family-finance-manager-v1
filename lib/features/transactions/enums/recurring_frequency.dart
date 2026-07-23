/// Enum representing recurring transaction frequencies
enum RecurringFrequency {
  daily,
  weekly,
  biweekly,
  monthly,
  quarterly,
  yearly,
}

/// Extension methods for RecurringFrequency
extension RecurringFrequencyExtension on RecurringFrequency {
  /// Get the display name for the frequency
  String get displayName {
    switch (this) {
      case RecurringFrequency.daily:
        return 'Daily';
      case RecurringFrequency.weekly:
        return 'Weekly';
      case RecurringFrequency.biweekly:
        return 'Bi-Weekly';
      case RecurringFrequency.monthly:
        return 'Monthly';
      case RecurringFrequency.quarterly:
        return 'Quarterly';
      case RecurringFrequency.yearly:
        return 'Yearly';
    }
  }

  /// Get the short display name for the frequency
  String get shortDisplayName {
    switch (this) {
      case RecurringFrequency.daily:
        return 'Daily';
      case RecurringFrequency.weekly:
        return 'Weekly';
      case RecurringFrequency.biweekly:
        return 'Bi-Weekly';
      case RecurringFrequency.monthly:
        return 'Monthly';
      case RecurringFrequency.quarterly:
        return 'Quarterly';
      case RecurringFrequency.yearly:
        return 'Yearly';
    }
  }

  /// Get the number of days between occurrences
  int get daysBetween {
    switch (this) {
      case RecurringFrequency.daily:
        return 1;
      case RecurringFrequency.weekly:
        return 7;
      case RecurringFrequency.biweekly:
        return 14;
      case RecurringFrequency.monthly:
        return 30;
      case RecurringFrequency.quarterly:
        return 90;
      case RecurringFrequency.yearly:
        return 365;
    }
  }

  /// Get the number of occurrences per year
  int get occurrencesPerYear {
    switch (this) {
      case RecurringFrequency.daily:
        return 365;
      case RecurringFrequency.weekly:
        return 52;
      case RecurringFrequency.biweekly:
        return 26;
      case RecurringFrequency.monthly:
        return 12;
      case RecurringFrequency.quarterly:
        return 4;
      case RecurringFrequency.yearly:
        return 1;
    }
  }

  /// Get the icon for the frequency
  String get iconName {
    switch (this) {
      case RecurringFrequency.daily:
        return 'today';
      case RecurringFrequency.weekly:
        return 'week';
      case RecurringFrequency.biweekly:
        return 'date_range';
      case RecurringFrequency.monthly:
        return 'calendar_month';
      case RecurringFrequency.quarterly:
        return 'calendar_view_month';
      case RecurringFrequency.yearly:
        return 'calendar_today';
    }
  }

  /// Get all frequencies
  static List<RecurringFrequency> get allFrequencies => values;

  /// Get default frequency
  static RecurringFrequency get defaultFrequency => RecurringFrequency.monthly;

  /// Parse frequency from string (case-insensitive)
  static RecurringFrequency parse(String value) {
    final lowerValue = value.toLowerCase();
    for (final freq in values) {
      if (freq.name.toLowerCase() == lowerValue) {
        return freq;
      }
      if (freq.displayName.toLowerCase() == lowerValue) {
        return freq;
      }
    }
    return defaultFrequency;
  }
}
