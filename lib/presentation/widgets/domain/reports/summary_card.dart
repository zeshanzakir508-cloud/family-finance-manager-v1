// lib/presentation/widgets/domain/reports/summary_card.dart

import 'package:flutter/material.dart';

import '../../cards/app_card.dart';
import '../../cards/enums/card_variant.dart';
import '../../cards/enums/card_elevation.dart';
import '../../data_display/app_counter.dart';

/// A summary card for report statistics.
///
/// This widget provides a standardized summary card for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// SummaryCard(
///   count: 245,
///   label: 'Transactions',
///   icon: Icons.receipt,
///   color: Colors.blue,
/// )
/// ```
class SummaryCard extends StatelessWidget {
  /// The count value.
  final int count;

  /// The label text.
  final String label;

  /// The optional icon.
  final IconData? icon;

  /// The color of the count.
  final Color? color;

  /// The subtitle (optional).
  final String? subtitle;

  /// Creates a new [SummaryCard].
  const SummaryCard({
    super.key,
    required this.count,
    required this.label,
    this.icon,
    this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: CardVariant.filled,
      elevation: CardElevation.low,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: color ?? Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color ?? Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
