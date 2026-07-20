// lib/presentation/widgets/domain/transactions/transaction_tile.dart

import 'package:flutter/material.dart';

import '../../tiles/app_tile.dart';
import '../../tiles/enums/tile_variant.dart';
import '../../tiles/enums/tile_size.dart';
import '../../tiles/enums/tile_density.dart';
import '../../badges/app_badge.dart';
import '../../badges/enums/badge_variant.dart';
import '../../badges/enums/badge_size.dart';
import '../../badges/enums/badge_shape.dart';

/// A compact transaction tile.
///
/// This widget provides a standardized transaction tile for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// TransactionTile(
///   title: 'Grocery Shopping',
///   amount: 1500.0,
///   currency: 'PKR',
///   categoryIcon: Icons.restaurant,
///   isIncome: false,
/// )
/// ```
class TransactionTile extends StatelessWidget {
  /// The transaction title.
  final String title;

  /// The transaction amount.
  final double amount;

  /// The currency symbol.
  final String currency;

  /// The category icon.
  final IconData? categoryIcon;

  /// Whether the transaction is income.
  final bool isIncome;

  /// The subtitle (optional).
  final String? subtitle;

  /// The status (optional).
  final String? status;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Creates a new [TransactionTile].
  const TransactionTile({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    this.categoryIcon,
    this.isIncome = false,
    this.subtitle,
    this.status,
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
        ? Icon(
            categoryIcon,
            color: isIncome ? colorScheme.primary : colorScheme.error,
          )
        : null;

    final trailing = status != null
        ? AppBadge(
            label: status!,
            variant: _getStatusVariant(status!),
            size: BadgeSize.small,
            shape: BadgeShape.pill,
          )
        : Text(
            formattedAmount,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.bold,
                ),
          );

    return AppTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      variant: TileVariant.filled,
      size: TileSize.compact,
      density: TileDensity.compact,
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
