// lib/presentation/widgets/charts/helpers/chart_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/chart_type.dart';

/// Builder class for creating consistent chart styles.
///
/// This class constructs [ChartStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for chart styling.
///
/// Example:
/// ```dart
/// final style = ChartStyleBuilder.build(
///   context: context,
///   type: ChartType.bar,
/// );
/// ```
abstract final class ChartStyleBuilder {
  /// Builds a [ChartStyle] configuration with the given parameters.
  static ChartStyle build({
    required BuildContext context,
    required ChartType type,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Color backgroundColor;
    Color gridColor;
    Color axisColor;
    Color labelColor;
    EdgeInsets padding;
    double borderRadius;

    switch (type) {
      case ChartType.line:
      case ChartType.area:
      case ChartType.sparkline:
        backgroundColor = Colors.transparent;
        gridColor = colorScheme.outlineVariant.withOpacity(0.3);
        axisColor = colorScheme.outlineVariant;
        labelColor = colorScheme.onSurfaceVariant;
        padding = const EdgeInsets.all(16);
        borderRadius = 0;
        break;

      case ChartType.bar:
      case ChartType.horizontalBar:
        backgroundColor = Colors.transparent;
        gridColor = colorScheme.outlineVariant.withOpacity(0.3);
        axisColor = colorScheme.outlineVariant;
        labelColor = colorScheme.onSurfaceVariant;
        padding = const EdgeInsets.all(16);
        borderRadius = 0;
        break;

      case ChartType.pie:
      case ChartType.donut:
        backgroundColor = Colors.transparent;
        gridColor = Colors.transparent;
        axisColor = Colors.transparent;
        labelColor = colorScheme.onSurfaceVariant;
        padding = const EdgeInsets.all(8);
        borderRadius = 0;
        break;

      case ChartType.scatter:
        backgroundColor = Colors.transparent;
        gridColor = colorScheme.outlineVariant.withOpacity(0.3);
        axisColor = colorScheme.outlineVariant;
        labelColor = colorScheme.onSurfaceVariant;
        padding = const EdgeInsets.all(16);
        borderRadius = 0;
        break;
    }

    final titleStyle = textTheme.titleLarge?.copyWith(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w600,
    ) ?? const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );

    final subtitleStyle = textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
    ) ?? const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );

    return ChartStyle(
      backgroundColor: backgroundColor,
      gridColor: gridColor,
      axisColor: axisColor,
      labelColor: labelColor,
      padding: padding,
      borderRadius: borderRadius,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
    );
  }
}

/// Style configuration for charts.
@immutable
class ChartStyle {
  /// The background color of the chart.
  final Color backgroundColor;

  /// The color of the grid lines.
  final Color gridColor;

  /// The color of the axes.
  final Color axisColor;

  /// The color of the axis labels.
  final Color labelColor;

  /// The padding inside the chart.
  final EdgeInsets padding;

  /// The border radius of the chart.
  final double borderRadius;

  /// The text style of the title.
  final TextStyle titleStyle;

  /// The text style of the subtitle.
  final TextStyle subtitleStyle;

  /// Creates a new [ChartStyle].
  const ChartStyle({
    required this.backgroundColor,
    required this.gridColor,
    required this.axisColor,
    required this.labelColor,
    required this.padding,
    required this.borderRadius,
    required this.titleStyle,
    required this.subtitleStyle,
  });
}
