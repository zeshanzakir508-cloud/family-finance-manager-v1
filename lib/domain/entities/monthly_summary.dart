// lib/domain/entities/monthly_summary.dart

import 'package:equatable/equatable.dart';

import 'daily_summary.dart';

/// Domain entity representing a monthly summary of transactions.
///
/// Contains aggregated transaction data for a user for a specific month,
/// including daily breakdowns and category summaries.
class MonthlySummary extends Equatable {
  /// The year of the summary.
  final int year;

  /// The month of the summary (1-12).
  final int month;

  /// Total income for the month.
  final double totalIncome;

  /// Total expense for the month.
  final double totalExpense;

  /// Net amount for the month (income - expense).
  final double netAmount;

  /// Total number of transactions for the month.
  final int transactionCount;

  /// Daily breakdown of transactions (day -> DailySummary).
  final Map<int, DailySummary> dailySummary;

  /// Income by category for the month.
  final Map<String, double> incomeByCategory;

  /// Expense by category for the month.
  final Map<String, double> expenseByCategory;

  const MonthlySummary({
    required this.year,
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.netAmount,
    required this.transactionCount,
    required this.dailySummary,
    required this.incomeByCategory,
    required this.expenseByCategory,
  });

  /// Creates a copy of this monthly summary with the given fields replaced.
  MonthlySummary copyWith({
    int? year,
    int? month,
    double? totalIncome,
    double? totalExpense,
    double? netAmount,
    int? transactionCount,
    Map<int, DailySummary>? dailySummary,
    Map<String, double>? incomeByCategory,
    Map<String, double>? expenseByCategory,
  }) {
    return MonthlySummary(
      year: year ?? this.year,
      month: month ?? this.month,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      netAmount: netAmount ?? this.netAmount,
      transactionCount: transactionCount ?? this.transactionCount,
      dailySummary: dailySummary ?? this.dailySummary,
      incomeByCategory: incomeByCategory ?? this.incomeByCategory,
      expenseByCategory: expenseByCategory ?? this.expenseByCategory,
    );
  }

  /// Gets the number of days in this month that have transactions.
  int get activeDays => dailySummary.length;

  /// Gets the average daily expense for this month.
  double get averageDailyExpense =>
      activeDays > 0 ? totalExpense / activeDays : 0.0;

  /// Gets the average daily income for this month.
  double get averageDailyIncome =>
      activeDays > 0 ? totalIncome / activeDays : 0.0;

  /// Gets the top income category for this month.
  MapEntry<String, double>? get topIncomeCategory {
    if (incomeByCategory.isEmpty) return null;
    return incomeByCategory.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
  }

  /// Gets the top expense category for this month.
  MapEntry<String, double>? get topExpenseCategory {
    if (expenseByCategory.isEmpty) return null;
    return expenseByCategory.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
  }

  @override
  List<Object?> get props => [
        year,
        month,
        totalIncome,
        totalExpense,
        netAmount,
        transactionCount,
        dailySummary,
        incomeByCategory,
        expenseByCategory,
      ];
}
