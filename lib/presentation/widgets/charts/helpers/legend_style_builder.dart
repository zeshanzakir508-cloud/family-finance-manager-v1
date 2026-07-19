// lib/presentation/widgets/charts/helpers/legend_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/chart_legend_position.dart';

/// Builder class for creating consistent legend styles.
///
/// This class constructs [LegendStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for legend styling.
///
/// Example:
/// ```dart
/// final style = LegendStyleBuilder.build(
///   context: context,
///   position: ChartLegendPosition.bottom,
/// );
/// ```
abstract final class LegendStyleBuilder {
  /// Builds a [LegendStyle] configuration with the given parameters.
  static LegendStyle build({
    required BuildContext context,
    required ChartLegendPosition position,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    EdgeInsets padding;
    double spacing;
    double runSpacing;
    Axis direction;

    switch (position) {
      case ChartLegendPosition.top:
      case ChartLegendPosition.bottom:
        padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 8);
        spacing = 16;
        runSpacing = 4;
        direction = Axis.horizontal;
        break;

      case ChartLegendPosition.left:
      case ChartLegendPosition.right:
        padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 0);
        spacing = 8;
        runSpacing = 8;
        direction = Axis.vertical;
        break;

      case ChartLegendPosition.overlay:
      case ChartLegendPosition.none:
        padding = EdgeInsets.zero;
        spacing = 0;
        runSpacing = 0;
        direction = Axis.horizontal;
        break;
    }

    return LegendStyle(
      textStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurface,
      ) ?? const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: padding,
      spacing: spacing,
      runSpacing: runSpacing,
      direction: direction,
      itemSize: 12,
      borderRadius: BorderRadius.circular(4),
    );
  }
}

/// Style configuration for chart legends.
@immutable
class LegendStyle {
  /// The text style of legend items.
  final TextStyle textStyle;

  /// The padding around the legend.
  final EdgeInsets padding;

  /// The spacing between legend items.
  final double spacing;

  /// The run spacing between legend rows.
  final double runSpacing;

  /// The direction of the legend layout.
  final Axis direction;

  /// The size of legend color indicators.
  final double itemSize;

  /// The border radius of legend items.
  final BorderRadius borderRadius;

  /// Creates a new [LegendStyle].
  const LegendStyle({
    required this.textStyle,
    required this.padding,
    required this.spacing,
    required this.runSpacing,
    required this.direction,
    required this.itemSize,
    required this.borderRadius,
  });
}
