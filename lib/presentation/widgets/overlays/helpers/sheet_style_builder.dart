// lib/presentation/widgets/overlays/helpers/sheet_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/overlay_variant.dart';

/// Builder class for creating consistent sheet styles.
///
/// This class constructs [SheetStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for sheet styling.
///
/// Example:
/// ```dart
/// final style = SheetStyleBuilder.build(
///   context: context,
///   variant: OverlayVariant.surface,
/// );
/// ```
abstract final class SheetStyleBuilder {
  /// Builds a [SheetStyle] configuration with the given parameters.
  static SheetStyle build({
    required BuildContext context,
    required OverlayVariant variant,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Color backgroundColor;
    Color foregroundColor;
    double borderRadius;
    double handleWidth;
    double handleHeight;
    double handleRadius;

    switch (variant) {
      case OverlayVariant.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        borderRadius = 16;
        handleWidth = 40;
        handleHeight = 4;
        handleRadius = 2;
        break;

      case OverlayVariant.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;
        borderRadius = 16;
        handleWidth = 40;
        handleHeight = 4;
        handleRadius = 2;
        break;

      case OverlayVariant.surface:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        borderRadius = 16;
        handleWidth = 40;
        handleHeight = 4;
        handleRadius = 2;
        break;

      case OverlayVariant.tonal:
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        borderRadius = 16;
        handleWidth = 40;
        handleHeight = 4;
        handleRadius = 2;
        break;

      case OverlayVariant.transparent:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        borderRadius = 0;
        handleWidth = 0;
        handleHeight = 0;
        handleRadius = 0;
        break;
    }

    final titleStyle = textTheme.titleLarge?.copyWith(
      color: foregroundColor,
      fontWeight: FontWeight.w600,
    ) ?? const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );

    final subtitleStyle = textTheme.bodyMedium?.copyWith(
      color: foregroundColor.withOpacity(0.7),
    ) ?? const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );

    return SheetStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderRadius: borderRadius,
      handleWidth: handleWidth,
      handleHeight: handleHeight,
      handleRadius: handleRadius,
      padding: const EdgeInsets.all(16),
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
    );
  }
}

/// Style configuration for sheets.
@immutable
class SheetStyle {
  /// The background color of the sheet.
  final Color backgroundColor;

  /// The foreground color (text) of the sheet.
  final Color foregroundColor;

  /// The border radius of the sheet.
  final double borderRadius;

  /// The width of the drag handle.
  final double handleWidth;

  /// The height of the drag handle.
  final double handleHeight;

  /// The radius of the drag handle.
  final double handleRadius;

  /// The padding inside the sheet.
  final EdgeInsets padding;

  /// The text style of the title.
  final TextStyle titleStyle;

  /// The text style of the subtitle.
  final TextStyle subtitleStyle;

  /// Creates a new [SheetStyle].
  const SheetStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderRadius,
    required this.handleWidth,
    required this.handleHeight,
    required this.handleRadius,
    required this.padding,
    required this.titleStyle,
    required this.subtitleStyle,
  });
}
