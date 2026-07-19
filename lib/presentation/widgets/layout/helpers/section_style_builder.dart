// lib/presentation/widgets/layout/helpers/section_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/section_variant.dart';

/// Builder class for creating consistent section styles.
///
/// This class constructs [SectionStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for section styling.
///
/// Example:
/// ```dart
/// final style = SectionStyleBuilder.build(
///   context: context,
///   variant: SectionVariant.filled,
/// );
/// ```
abstract final class SectionStyleBuilder {
  /// Builds a [SectionStyle] configuration with the given parameters.
  static SectionStyle build({
    required BuildContext context,
    required SectionVariant variant,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? border;
    double elevation;
    EdgeInsets padding;
    EdgeInsets margin;

    switch (variant) {
      case SectionVariant.normal:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        border = null;
        elevation = 0;
        padding = const EdgeInsets.all(0);
        margin = const EdgeInsets.all(0);
        break;

      case SectionVariant.filled:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        border = null;
        elevation = 0;
        padding = const EdgeInsets.all(16);
        margin = const EdgeInsets.symmetric(vertical: 8);
        break;

      case SectionVariant.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        border = BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        );
        elevation = 0;
        padding = const EdgeInsets.all(16);
        margin = const EdgeInsets.symmetric(vertical: 8);
        break;

      case SectionVariant.tonal:
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        border = null;
        elevation = 0;
        padding = const EdgeInsets.all(16);
        margin = const EdgeInsets.symmetric(vertical: 8);
        break;
    }

    final titleStyle = textTheme.titleMedium?.copyWith(
      color: foregroundColor,
      fontWeight: FontWeight.w600,
    ) ?? const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    final subtitleStyle = textTheme.bodySmall?.copyWith(
      color: foregroundColor.withOpacity(0.7),
    ) ?? const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );

    return SectionStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: padding,
      margin: margin,
      border: border,
      elevation: elevation,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      borderRadius: BorderRadius.circular(12),
    );
  }
}

/// Style configuration for sections.
@immutable
class SectionStyle {
  /// The background color of the section.
  final Color backgroundColor;

  /// The foreground color (text) of the section.
  final Color foregroundColor;

  /// The padding inside the section.
  final EdgeInsets padding;

  /// The margin around the section.
  final EdgeInsets margin;

  /// The border of the section, if any.
  final BorderSide? border;

  /// The elevation (shadow depth) of the section.
  final double elevation;

  /// The text style of the title.
  final TextStyle titleStyle;

  /// The text style of the subtitle.
  final TextStyle subtitleStyle;

  /// The border radius of the section.
  final BorderRadius borderRadius;

  /// Creates a new [SectionStyle].
  const SectionStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.padding,
    required this.margin,
    this.border,
    required this.elevation,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.borderRadius,
  });
}
