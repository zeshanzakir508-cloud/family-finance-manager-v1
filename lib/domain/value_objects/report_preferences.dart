// lib/domain/value_objects/report_preferences.dart

import 'package:equatable/equatable.dart';

import '../enums/weekday.dart';

/// Value object representing report preferences.
class ReportPreferences extends Equatable {
  /// Number of recent transactions to show.
  final int recentTransactionsCount;

  /// Budget alert threshold percentage.
  final double budgetAlertThreshold;

  /// Day of week for weekly report.
  final Weekday weeklyReportDay;

  /// Day of month for monthly report (1-31).
  final int monthlyReportDay;

  const ReportPreferences({
    this.recentTransactionsCount = 10,
    this.budgetAlertThreshold = 80.0,
    this.weeklyReportDay = Weekday.sunday,
    this.monthlyReportDay = 1,
  })  : assert(recentTransactionsCount > 0, 'Recent transactions count must be greater than 0'),
        assert(
          budgetAlertThreshold >= 0 && budgetAlertThreshold <= 100,
          'Budget alert threshold must be between 0 and 100',
        ),
        assert(
          monthlyReportDay >= 1 && monthlyReportDay <= 31,
          'Monthly report day must be between 1 and 31',
        );

  /// Creates a copy of these report preferences with the given fields replaced.
  ReportPreferences copyWith({
    int? recentTransactionsCount,
    double? budgetAlertThreshold,
    Weekday? weeklyReportDay,
    int? monthlyReportDay,
  }) {
    return ReportPreferences(
      recentTransactionsCount: recentTransactionsCount ?? this.recentTransactionsCount,
      budgetAlertThreshold: budgetAlertThreshold ?? this.budgetAlertThreshold,
      weeklyReportDay: weeklyReportDay ?? this.weeklyReportDay,
      monthlyReportDay: monthlyReportDay ?? this.monthlyReportDay,
    );
  }

  /// Returns whether the budget alert threshold is set.
  bool get hasBudgetAlert => budgetAlertThreshold > 0;

  @override
  List<Object?> get props => [
        recentTransactionsCount,
        budgetAlertThreshold,
        weeklyReportDay,
        monthlyReportDay,
      ];
}
