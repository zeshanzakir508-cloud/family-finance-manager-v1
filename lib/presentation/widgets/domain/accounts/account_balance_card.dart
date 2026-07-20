// lib/presentation/widgets/domain/accounts/account_balance_card.dart

import 'package:flutter/material.dart';

import '../../cards/app_card.dart';
import '../../cards/enums/card_variant.dart';
import '../../cards/enums/card_elevation.dart';
import '../../data_display/app_statistic_card.dart';
import '../../data_display/enums/statistic_variant.dart';

/// A card displaying account balance information.
///
/// This widget provides a standardized account balance card for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// AccountBalanceCard(
///   accountName: 'Bank Al Habib',
///   balance: 56200.0,
///   currency: 'PKR',
///   icon: Icons.account_balance,
/// )
/// ```
class AccountBalanceCard extends StatelessWidget {
  /// The account name.
  final String accountName;

  /// The account balance.
  final double balance;

  /// The currency symbol.
  final String currency;

  /// The account icon.
  final IconData? icon;

  /// The account number (optional).
  final String? accountNumber;

  /// Whether the balance is positive.
  final bool isPositive;

  /// The account type (e.g., 'Savings', 'Current').
  final String? accountType;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Creates a new [AccountBalanceCard].
  const AccountBalanceCard({
    super.key,
    required this.accountName,
    required this.balance,
    required this.currency,
    this.icon,
    this.accountNumber,
    this.isPositive = true,
    this.accountType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final variant = isPositive
        ? StatisticVariant.success
        : StatisticVariant.error;

    final formattedBalance = _formatBalance(balance, currency);

    return AppCard(
      variant: CardVariant.filled,
      elevation: CardElevation.low,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: colorScheme.primary, size: 24),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accountName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (accountNumber != null)
                      Text(
                        accountNumber!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                  ],
                ),
              ),
              if (accountType != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    accountType!,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formattedBalance,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isPositive
                      ? colorScheme.primary
                      : colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  String _formatBalance(double balance, String currency) {
    final sign = balance >= 0 ? '' : '-';
    final absBalance = balance.abs();
    return '$sign$currency ${absBalance.toStringAsFixed(2)}';
  }
}
