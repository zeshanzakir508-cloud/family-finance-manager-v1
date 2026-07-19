// lib/presentation/widgets/layout/helpers/divider_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/divider_variant.dart';

/// Builder class for creating consistent divider styles.
///
/// This class constructs [DividerStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for divider styling.
///
/// Example:
/// ```dart
/// final style = DividerStyleBuilder.build(
///   variant: DividerVariant.full,
/// );
/// ```
abstract final class DividerStyleBuilder {
  /// Builds a [DividerStyle] configuration with the given parameters.
  static DividerStyle build({
    required BuildContext context,
    required DividerVariant variant,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    double thickness;
    double indent;
    double endIndent;

    switch (variant) {
      case DividerVariant.full:
        thickness = 1;
        indent = 0;
        endIndent = 0;
        break;

      case DividerVariant.indented:
        thickness = 1;
        indent = 16;
        endIndent = 16;
        break;

      case DividerVariant.center:
        thickness = 1;
        indent = 0;
        endIndent = 0;
        break;
    }

    final labelStyle = textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    ) ?? const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    return DividerStyle(
      color: colorScheme.outlineVariant,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      labelStyle: labelStyle,
    );
  }
}

/// Style configuration for dividers.
@immutable
class DividerStyle {
  /// The color of the divider.
  final Color color;

  /// The thickness of the divider.
  final double thickness;

  /// The indent from the start.
  final double indent;

  /// The indent from the end.
  final double endIndent;

  /// The text style for center divider labels.
  final TextStyle labelStyle;

  /// Creates a new [DividerStyle].
  const DividerStyle({
    required this.color,
    required this.thickness,
    required this.indent,
    required this.endIndent,
    required this.labelStyle,
  });
}
