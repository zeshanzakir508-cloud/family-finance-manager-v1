// lib/presentation/widgets/charts/helpers/axis_style_builder.dart

import 'package:flutter/material.dart';

/// Builder class for creating consistent axis styles.
///
/// This class constructs [AxisStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for axis styling.
///
/// Example:
/// ```dart
/// final style = AxisStyleBuilder.build(
///   context: context,
///   showGrid: true,
/// );
/// ```
abstract final class AxisStyleBuilder {
  /// Builds an [AxisStyle] configuration with the given parameters.
  static AxisStyle build({
    required BuildContext context,
    required bool showGrid,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AxisStyle(
      labelStyle: textTheme.labelSmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ) ?? const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
      ),
      gridColor: colorScheme.outlineVariant.withOpacity(0.3),
      axisColor: colorScheme.outlineVariant,
      tickLength: 4,
      gridWidth: 0.5,
      axisWidth: 1,
      showGrid: showGrid,
    );
  }
}

/// Style configuration for chart axes.
@immutable
class AxisStyle {
  /// The text style of axis labels.
  final TextStyle labelStyle;

  /// The color of the grid lines.
  final Color gridColor;

  /// The color of the axis lines.
  final Color axisColor;

  /// The length of tick marks.
  final double tickLength;

  /// The width of grid lines.
  final double gridWidth;

  /// The width of axis lines.
  final double axisWidth;

  /// Whether to show grid lines.
  final bool showGrid;

  /// Creates a new [AxisStyle].
  const AxisStyle({
    required this.labelStyle,
    required this.gridColor,
    required this.axisColor,
    required this.tickLength,
    required this.gridWidth,
    required this.axisWidth,
    required this.showGrid,
  });
}
