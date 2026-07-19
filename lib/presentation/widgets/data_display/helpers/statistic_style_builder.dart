// lib/presentation/widgets/data_display/helpers/statistic_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/statistic_variant.dart';

/// Builder class for creating consistent statistic styles.
///
/// This class constructs [StatisticStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for statistic styling.
///
/// Example:
/// ```dart
/// final style = StatisticStyleBuilder.build(
///   context: context,
///   variant: StatisticVariant.primary,
/// );
/// ```
abstract final class StatisticStyleBuilder {
  /// Builds a [StatisticStyle] configuration with the given parameters.
  static StatisticStyle build({
    required BuildContext context,
    required StatisticVariant variant,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Color valueColor;
    Color labelColor;
    Color backgroundColor;
    IconData? icon;

    switch (variant) {
      case StatisticVariant.primary:
        valueColor = colorScheme.primary;
        labelColor = colorScheme.onSurfaceVariant;
        backgroundColor = colorScheme.surface;
        icon = null;
        break;

      case StatisticVariant.secondary:
        valueColor = colorScheme.secondary;
        labelColor = colorScheme.onSurfaceVariant;
        backgroundColor = colorScheme.surface;
        icon = null;
        break;

      case StatisticVariant.success:
        valueColor = colorScheme.primary;
        labelColor = colorScheme.onSurfaceVariant;
        backgroundColor = colorScheme.surface;
        icon = Icons.trending_up;
        break;

      case StatisticVariant.warning:
        valueColor = colorScheme.tertiary;
        labelColor = colorScheme.onSurfaceVariant;
        backgroundColor = colorScheme.surface;
        icon = Icons.warning;
        break;

      case StatisticVariant.error:
        valueColor = colorScheme.error;
        labelColor = colorScheme.onSurfaceVariant;
        backgroundColor = colorScheme.surface;
        icon = Icons.trending_down;
        break;

      case StatisticVariant.neutral:
        valueColor = colorScheme.onSurface;
        labelColor = colorScheme.onSurfaceVariant;
        backgroundColor = colorScheme.surface;
        icon = null;
        break;
    }

    final valueStyle = textTheme.headlineMedium?.copyWith(
      color: valueColor,
      fontWeight: FontWeight.bold,
    ) ?? const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    );

    final labelStyle = textTheme.bodyMedium?.copyWith(
      color: labelColor,
    ) ?? const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );

    return StatisticStyle(
      valueColor: valueColor,
      labelColor: labelColor,
      backgroundColor: backgroundColor,
      icon: icon,
      valueStyle: valueStyle,
      labelStyle: labelStyle,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
    );
  }
}

/// Style configuration for statistics.
@immutable
class StatisticStyle {
  /// The color of the value text.
  final Color valueColor;

  /// The color of the label text.
  final Color labelColor;

  /// The background color of the statistic.
  final Color backgroundColor;

  /// The icon to display.
  final IconData? icon;

  /// The text style of the value.
  final TextStyle valueStyle;

  /// The text style of the label.
  final TextStyle labelStyle;

  /// The padding inside the statistic.
  final EdgeInsets padding;

  /// The border radius of the statistic.
  final BorderRadius borderRadius;

  /// Creates a new [StatisticStyle].
  const StatisticStyle({
    required this.valueColor,
    required this.labelColor,
    required this.backgroundColor,
    this.icon,
    required this.valueStyle,
    required this.labelStyle,
    required this.padding,
    required this.borderRadius,
  });
}
