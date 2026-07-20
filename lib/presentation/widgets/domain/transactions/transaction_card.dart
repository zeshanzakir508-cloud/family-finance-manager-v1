// lib/presentation/widgets/domain/transactions/transaction_card.dart

import 'package:flutter/material.dart';

import '../../cards/app_card.dart';
import '../../cards/enums/card_variant.dart';
import '../../cards/enums/card_elevation.dart';
import '../../tiles/app_tile.dart';
import '../../tiles/enums/tile_variant.dart';
import '../../tiles/enums/tile_size.dart';
import '../../tiles/enums/tile_density.dart';
import '../../badges/app_badge.dart';
import '../../badges/enums/badge_variant.dart';
import '../../badges/enums/badge_size.dart';
import '../../badges/enums/badge_shape.dart';

/// A card displaying transaction information.
///
/// This widget provides a standardized transaction card for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// TransactionCard(
///   title: 'Grocery Shopping',
///   amount: 1500.0,
///   currency: 'PKR',
///   category: 'Food',
///   categoryIcon: Icons.restaurant,
///   date: 'Today',
///   status: 'Completed',
///   isIncome: false,
/// )
/// ```
class TransactionCard extends StatelessWidget {
  /// The transaction title/description.
  final String title;

  /// The transaction amount.
  final double amount;

  /// The currency symbol.
  final String currency;

  /// The category name.
  final String? category;

  /// The category icon.
  final IconData? categoryIcon;

  /// The transaction date.
  final String? date;

  /// The transaction status.
  final String? status;

  /// Whether the transaction is income.
  final bool isIncome;

  /// The account name (optional).
  final String? account;

  /// The note (optional).
  final String? note;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Creates a new [TransactionCard].
  const TransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    this.category,
    this.categoryIcon,
    this.date,
    this.status,
    this.isIncome = false,
    this.account,
    this.note,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final amountColor = isIncome
        ? colorScheme.primary
        : colorScheme.error;

    final formattedAmount = '${isIncome ? '+' : '-'}$currency ${amount.abs().toStringAsFixed(2)}';

    final leading = categoryIcon != null
        ? CircleAvatar(
            backgroundColor: colorScheme.surfaceVariant,
            child: Icon(
              categoryIcon,
              color: colorScheme.primary,
            ),
          )
        : null;

    final trailing = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formattedAmount,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: amountColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        if (status != null)
          AppBadge(
            label: status,
            variant: _getStatusVariant(status!),
            size: BadgeSize.small,
            shape: BadgeShape.pill,
          ),
      ],
    );

    final subtitle = <String>[];
    if (category != null) subtitle.add(category!);
    if (date != null) subtitle.add(date!);
    if (account != null) subtitle.add(account!);
    final subtitleText = subtitle.join(' • ');

    return AppCard(
      variant: CardVariant.filled,
      elevation: CardElevation.low,
      onTap: onTap,
      child: AppTile(
        title: title,
        subtitle: subtitleText.isNotEmpty ? subtitleText : note,
        leading: leading,
        trailing: trailing,
        variant: TileVariant.normal,
        size: TileSize.medium,
        density: TileDensity.comfortable,
      ),
    );
  }

  BadgeVariant _getStatusVariant(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('completed') || lower.contains('approved')) {
      return BadgeVariant.success;
    }
    if (lower.contains('pending')) {
      return BadgeVariant.warning;
    }
    if (lower.contains('failed') || lower.contains('cancelled')) {
      return BadgeVariant.error;
    }
    return BadgeVariant.neutral;
  }
}
