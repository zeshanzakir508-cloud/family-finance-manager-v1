// lib/domain/entities/transaction_summary.dart

import 'package:equatable/equatable.dart';

/// Domain entity representing a summary of transactions.
///
/// Contains aggregated transaction data for a user within a date range.
/// Used for financial reporting and dashboard analytics.
class TransactionSummary extends Equatable {
  /// Total income amount.
  final double totalIncome;

  /// Total expense amount.
  final double totalExpense;

  /// Net amount (total income - total expense).
  final double netAmount;

  /// Total number of transactions.
  final int transactionCount;

  /// Income amount by category ID.
  final Map<String, double> incomeByCategory;

  /// Expense amount by category ID.
  final Map<String, double> expenseByCategory;

  const TransactionSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netAmount,
    required this.transactionCount,
    required this.incomeByCategory,
    required this.expenseByCategory,
  });

  /// Creates a copy of this transaction summary with the given fields replaced.
  TransactionSummary copyWith({
    double? totalIncome,
    double? totalExpense,
    double? netAmount,
    int? transactionCount,
    Map<String, double>? incomeByCategory,
    Map<String, double>? expenseByCategory,
  }) {
    return TransactionSummary(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      netAmount: netAmount ?? this.netAmount,
      transactionCount: transactionCount ?? this.transactionCount,
      incomeByCategory: incomeByCategory ?? this.incomeByCategory,
      expenseByCategory: expenseByCategory ?? this.expenseByCategory,
    );
  }

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        netAmount,
        transactionCount,
        incomeByCategory,
        expenseByCategory,
      ];
}
