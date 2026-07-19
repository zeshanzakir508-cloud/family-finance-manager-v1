// lib/presentation/widgets/data_display/helpers/label_style_builder.dart

import 'package:flutter/material.dart';

/// Builder class for creating consistent label styles.
///
/// This class constructs [LabelStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for label styling.
///
/// Example:
/// ```dart
/// final style = LabelStyleBuilder.build(
///   context: context,
///   variant: 'primary',
/// );
/// ```
abstract final class LabelStyleBuilder {
  /// Builds a [LabelStyle] configuration with the given parameters.
  static LabelStyle build({
    required BuildContext context,
    required String variant,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Color backgroundColor;
    Color foregroundColor;

    switch (variant.toLowerCase()) {
      case 'primary':
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        break;

      case 'secondary':
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;
        break;

      case 'success':
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        break;

      case 'warning':
        backgroundColor = colorScheme.tertiary;
        foregroundColor = colorScheme.onTertiary;
        break;

      case 'error':
        backgroundColor = colorScheme.error;
        foregroundColor = colorScheme.onError;
        break;

      default:
        backgroundColor = colorScheme.surfaceVariant;
        foregroundColor = colorScheme.onSurfaceVariant;
        break;
    }

    return LabelStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textStyle: textTheme.labelSmall?.copyWith(
        color: foregroundColor,
        fontWeight: FontWeight.w500,
      ) ?? const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      borderRadius: BorderRadius.circular(4),
    );
  }
}

/// Style configuration for labels.
@immutable
class LabelStyle {
  /// The background color of the label.
  final Color backgroundColor;

  /// The foreground color (text) of the label.
  final Color foregroundColor;

  /// The text style of the label.
  final TextStyle textStyle;

  /// The padding inside the label.
  final EdgeInsets padding;

  /// The border radius of the label.
  final BorderRadius borderRadius;

  /// Creates a new [LabelStyle].
  const LabelStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.textStyle,
    required this.padding,
    required this.borderRadius,
  });
}
