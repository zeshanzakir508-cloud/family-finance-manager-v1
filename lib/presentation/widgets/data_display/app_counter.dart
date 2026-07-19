// lib/presentation/widgets/data_display/app_counter.dart

import 'package:flutter/material.dart';

import '../cards/app_card.dart';
import '../cards/enums/card_variant.dart';
import '../cards/enums/card_elevation.dart';

/// A counter widget for displaying numeric counts.
///
/// This widget provides a standardized counter that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppCounter(
///   count: 245,
///   label: 'Transactions',
///   icon: Icons.receipt,
/// )
/// ```
class AppCounter extends StatelessWidget {
  /// The count to display.
  final int count;

  /// The label text.
  final String? label;

  /// The optional icon.
  final IconData? icon;

  /// The color of the count.
  final Color? color;

  /// Creates a new [AppCounter].
  const AppCounter({
    super.key,
    required this.count,
    this.label,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final effectiveColor = color ?? colorScheme.primary;

    return AppCard(
      variant: CardVariant.filled,
      elevation: CardElevation.low,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: effectiveColor,
              size: 28,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.toString(),
                  style: textTheme.headlineMedium?.copyWith(
                    color: effectiveColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (label != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    label!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
