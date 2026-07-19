// lib/presentation/widgets/data_display/helpers/timeline_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/timeline_variant.dart';

/// Builder class for creating consistent timeline styles.
///
/// This class constructs [TimelineStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for timeline styling.
///
/// Example:
/// ```dart
/// final style = TimelineStyleBuilder.build(
///   variant: TimelineVariant.vertical,
/// );
/// ```
abstract final class TimelineStyleBuilder {
  /// Builds a [TimelineStyle] configuration with the given parameters.
  static TimelineStyle build({
    required BuildContext context,
    required TimelineVariant variant,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    double nodeSize;
    double lineWidth;
    double spacing;

    switch (variant) {
      case TimelineVariant.vertical:
        nodeSize = 12;
        lineWidth = 2;
        spacing = 16;
        break;

      case TimelineVariant.horizontal:
        nodeSize = 10;
        lineWidth = 2;
        spacing = 12;
        break;
    }

    return TimelineStyle(
      nodeSize: nodeSize,
      lineWidth: lineWidth,
      spacing: spacing,
      nodeColor: colorScheme.primary,
      lineColor: colorScheme.outlineVariant,
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
      ) ?? const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

/// Style configuration for timelines.
@immutable
class TimelineStyle {
  /// The size of the timeline node.
  final double nodeSize;

  /// The width of the timeline line.
  final double lineWidth;

  /// The spacing between timeline items.
  final double spacing;

  /// The color of the timeline node.
  final Color nodeColor;

  /// The color of the timeline line.
  final Color lineColor;

  /// The text style of the timeline item.
  final TextStyle textStyle;

  /// Creates a new [TimelineStyle].
  const TimelineStyle({
    required this.nodeSize,
    required this.lineWidth,
    required this.spacing,
    required this.nodeColor,
    required this.lineColor,
    required this.textStyle,
  });
}
