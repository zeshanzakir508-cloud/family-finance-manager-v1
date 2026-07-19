// lib/presentation/widgets/badges/app_count_badge.dart

import 'package:flutter/material.dart';

import 'app_badge.dart';
import 'enums/badge_variant.dart';
import 'enums/badge_size.dart';
import 'enums/badge_shape.dart';

/// A count badge for displaying numeric counts.
///
/// This widget provides a standardized count badge with automatic
/// formatting for large numbers.
///
/// Example:
/// ```dart
/// AppCountBadge(
///   count: 42,
///   variant: BadgeVariant.primary,
///   maxCount: 99,
/// )
/// ```
class AppCountBadge extends StatelessWidget {
  /// The count to display.
  final int count;

  /// The maximum count before showing a "+" suffix.
  final int maxCount;

  /// The visual variant of the badge.
  final BadgeVariant variant;

  /// The size of the badge.
  final BadgeSize size;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Creates a new [AppCountBadge].
  const AppCountBadge({
    super.key,
    required this.count,
    this.maxCount = 99,
    this.variant = BadgeVariant.primary,
    this.size = BadgeSize.small,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final label = _formatCount(count, maxCount);

    return AppBadge(
      label: label,
      variant: variant,
      size: size,
      shape: BadgeShape.circular,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  String _formatCount(int count, int maxCount) {
    if (count <= 0) return '0';
    if (count > maxCount) return '$maxCount+';
    return count.toString();
  }
}
