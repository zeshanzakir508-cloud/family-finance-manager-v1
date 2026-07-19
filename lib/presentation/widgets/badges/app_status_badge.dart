// lib/presentation/widgets/badges/app_status_badge.dart

import 'package:flutter/material.dart';

import 'app_badge.dart';
import 'enums/badge_variant.dart';
import 'enums/badge_size.dart';
import 'enums/badge_shape.dart';

/// A status badge for displaying status indicators.
///
/// This widget provides a standardized status badge with a dot indicator
/// and optional label.
///
/// Example:
/// ```dart
/// AppStatusBadge(
///   label: 'Active',
///   variant: BadgeVariant.success,
///   showDot: true,
/// )
/// ```
class AppStatusBadge extends StatelessWidget {
  /// The label text to display.
  final String label;

  /// The visual variant of the badge.
  final BadgeVariant variant;

  /// The size of the badge.
  final BadgeSize size;

  /// Whether to show a dot indicator.
  final bool showDot;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Creates a new [AppStatusBadge].
  const AppStatusBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.size = BadgeSize.small,
    this.showDot = true,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final style = BadgeStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
      shape: BadgeShape.pill,
    );

    final colors = style.resolve(
      selected: false,
      disabled: false,
    );

    final fgColor = foregroundColor ?? colors.foreground;

    return AppBadge(
      label: label,
      variant: variant,
      size: size,
      shape: BadgeShape.pill,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      icon: showDot ? Icons.circle : null,
    );
  }
}
