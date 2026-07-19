// lib/presentation/widgets/badges/app_dot_badge.dart

import 'package:flutter/material.dart';

import 'app_badge.dart';
import 'enums/badge_variant.dart';
import 'enums/badge_size.dart';
import 'enums/badge_shape.dart';

/// A dot badge for displaying a small indicator dot.
///
/// This widget provides a standardized dot badge for indicating
/// status, presence, or notifications.
///
/// Example:
/// ```dart
/// AppDotBadge(
///   variant: BadgeVariant.success,
///   size: BadgeSize.small,
/// )
/// ```
class AppDotBadge extends StatelessWidget {
  /// The visual variant of the badge.
  final BadgeVariant variant;

  /// The size of the badge.
  final BadgeSize size;

  /// Custom color override.
  final Color? color;

  /// Whether the badge has a border.
  final bool hasBorder;

  /// Creates a new [AppDotBadge].
  const AppDotBadge({
    super.key,
    this.variant = BadgeVariant.primary,
    this.size = BadgeSize.small,
    this.color,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final style = BadgeStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
      shape: BadgeShape.circular,
    );

    final bgColor = color ?? style.backgroundColor;

    return Container(
      width: style.size / 2,
      height: style.size / 2,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: hasBorder
            ? Border.all(
                color: colorScheme.surface,
                width: 1.5,
              )
            : null,
      ),
    );
  }
}
