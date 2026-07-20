// lib/presentation/widgets/domain/transactions/transaction_amount.dart

import 'package:flutter/material.dart';

/// A widget for displaying transaction amounts.
///
/// This widget provides a standardized transaction amount display for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// TransactionAmount(
///   amount: 1500.0,
///   currency: 'PKR',
///   isIncome: false,
///   size: 20,
/// )
/// ```
class TransactionAmount extends StatelessWidget {
  /// The amount value.
  final double amount;

  /// The currency symbol.
  final String currency;

  /// Whether the amount is income.
  final bool isIncome;

  /// The text size.
  final double? size;

  /// The color override.
  final Color? color;

  /// Creates a new [TransactionAmount].
  const TransactionAmount({
    super.key,
    required this.amount,
    required this.currency,
    this.isIncome = false,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final textColor = color ??
        (isIncome
            ? colorScheme.primary
            : colorScheme.error);

    final sign = isIncome ? '+' : '-';
    final formattedAmount = '$sign$currency ${amount.abs().toStringAsFixed(2)}';

    return Text(
      formattedAmount,
      style: TextStyle(
        color: textColor,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
