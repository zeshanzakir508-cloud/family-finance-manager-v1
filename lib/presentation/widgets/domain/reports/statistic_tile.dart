// lib/presentation/widgets/domain/reports/statistic_tile.dart

import 'package:flutter/material.dart';

import '../../tiles/app_tile.dart';
import '../../tiles/enums/tile_variant.dart';
import '../../tiles/enums/tile_size.dart';
import '../../tiles/enums/tile_density.dart';

/// A statistic tile for report data.
///
/// This widget provides a standardized statistic tile for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// StatisticTile(
///   label: 'Total Income',
///   value: 'PKR 125,000',
///   icon: Icons.arrow_upward,
///   color: Colors.green,
/// )
/// ```
class StatisticTile extends StatelessWidget {
  /// The statistic label.
  final String label;

  /// The statistic value.
  final String value;

  /// The optional icon.
  final IconData? icon;

  /// The color of the value.
  final Color? color;

  /// The subtitle (optional).
  final String? subtitle;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Creates a new [StatisticTile].
  const StatisticTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveColor = color ?? colorScheme.primary;

    final leading = icon != null
        ? Icon(icon, color: effectiveColor)
        : null;

    final trailing = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: effectiveColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
      ],
    );

    return AppTile(
      title: label,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      variant: TileVariant.filled,
      size: TileSize.medium,
      density: TileDensity.comfortable,
    );
  }
}
