// lib/core/enums/billing_interval.dart

/// Enum representing billing intervals for subscriptions.
enum BillingInterval {
  /// Billed daily.
  daily,

  /// Billed weekly.
  weekly,

  /// Billed monthly.
  monthly,

  /// Billed quarterly (every 3 months).
  quarterly,

  /// Billed semi-annually (every 6 months).
  semiAnnually,

  /// Billed annually (yearly).
  yearly,
}

/// Extension methods for [BillingInterval].
extension BillingIntervalExtension on BillingInterval {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [BillingInterval] from a stored string value.
  static BillingInterval fromValue(String value) {
    return BillingInterval.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BillingInterval.monthly,
    );
  }

  /// Returns the number of months in this billing interval.
  /// Returns null for daily and weekly intervals (not applicable).
  int? get monthsInInterval {
    switch (this) {
      case BillingInterval.daily:
        return null;
      case BillingInterval.weekly:
        return null;
      case BillingInterval.monthly:
        return 1;
      case BillingInterval.quarterly:
        return 3;
      case BillingInterval.semiAnnually:
        return 6;
      case BillingInterval.yearly:
        return 12;
    }
  }

  /// Returns whether this is a monthly or longer interval.
  bool get isMonthlyOrLonger {
    return this == BillingInterval.monthly ||
        this == BillingInterval.quarterly ||
        this == BillingInterval.semiAnnually ||
        this == BillingInterval.yearly;
  }

  /// Returns whether this is a daily or weekly interval.
  bool get isShortInterval {
    return this == BillingInterval.daily || this == BillingInterval.weekly;
  }
}
