// lib/presentation/widgets/charts/helpers/tooltip_style_builder.dart

import 'package:flutter/material.dart';

/// Builder class for creating consistent tooltip styles.
///
/// This class constructs [TooltipStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for tooltip styling.
///
/// Example:
/// ```dart
/// final style = TooltipStyleBuilder.build(
///   context: context,
/// );
/// ```
abstract final class TooltipStyleBuilder {
  /// Builds a [TooltipStyle] configuration with the given parameters.
  static TooltipStyle build({
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return TooltipStyle(
      backgroundColor: colorScheme.inverseSurface,
      textColor: colorScheme.onInverseSurface,
      textStyle: textTheme.bodySmall?.copyWith(
        color: colorScheme.onInverseSurface,
      ) ?? const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(4),
      elevation: 4,
    );
  }
}

/// Style configuration for chart tooltips.
@immutable
class TooltipStyle {
  /// The background color of the tooltip.
  final Color backgroundColor;

  /// The text color of the tooltip.
  final Color textColor;

  /// The text style of the tooltip.
  final TextStyle textStyle;

  /// The padding inside the tooltip.
  final EdgeInsets padding;

  /// The border radius of the tooltip.
  final BorderRadius borderRadius;

  /// The elevation of the tooltip.
  final double elevation;

  /// Creates a new [TooltipStyle].
  const TooltipStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.textStyle,
    required this.padding,
    required this.borderRadius,
    required this.elevation,
  });
}
