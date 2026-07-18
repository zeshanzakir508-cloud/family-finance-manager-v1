// lib/domain/value_objects/daily_summary.dart

import 'package:equatable/equatable.dart';

/// Value object representing a daily summary of transactions.
///
/// Contains aggregated transaction data for a specific day,
/// used as part of the monthly summary.
class DailySummary extends Equatable {
  /// The day of the month (1-31).
  final int day;

  /// Total income for the day.
  final double totalIncome;

  /// Total expense for the day.
  final double totalExpense;

  /// Number of transactions for the day.
  final int transactionCount;

  const DailySummary({
    required this.day,
    required this.totalIncome,
    required this.totalExpense,
    required this.transactionCount,
  })  : assert(day >= 1 && day <= 31, 'Day must be between 1 and 31'),
        assert(totalIncome >= 0, 'Total income cannot be negative'),
        assert(totalExpense >= 0, 'Total expense cannot be negative'),
        assert(transactionCount >= 0, 'Transaction count cannot be negative');

  /// Creates a copy of this daily summary with the given fields replaced.
  DailySummary copyWith({
    int? day,
    double? totalIncome,
    double? totalExpense,
    int? transactionCount,
  }) {
    return DailySummary(
      day: day ?? this.day,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      transactionCount: transactionCount ?? this.transactionCount,
    );
  }

  /// Net amount for the day (income - expense).
  double get netAmount => totalIncome - totalExpense;

  /// Whether the day had any transactions.
  bool get hasTransactions => transactionCount > 0;

  /// Whether the day had a positive net amount (income > expense).
  bool get isPositiveDay => netAmount > 0;

  /// Whether the day had a negative net amount (expense > income).
  bool get isNegativeDay => netAmount < 0;

  /// Whether the day broke even (income == expense).
  bool get isBreakEvenDay => netAmount == 0;

  @override
  List<Object?> get props => [
        day,
        totalIncome,
        totalExpense,
        transactionCount,
      ];
}
