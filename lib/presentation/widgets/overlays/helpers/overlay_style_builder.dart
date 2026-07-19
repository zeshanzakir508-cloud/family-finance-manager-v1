// lib/presentation/widgets/overlays/helpers/overlay_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/overlay_variant.dart';

/// Builder class for creating consistent overlay styles.
///
/// This class constructs [OverlayStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for overlay styling.
///
/// Example:
/// ```dart
/// final style = OverlayStyleBuilder.build(
///   context: context,
///   variant: OverlayVariant.surface,
/// );
/// ```
abstract final class OverlayStyleBuilder {
  /// Builds an [OverlayStyle] configuration with the given parameters.
  static OverlayStyle build({
    required BuildContext context,
    required OverlayVariant variant,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Color backgroundColor;
    Color foregroundColor;
    double elevation;
    EdgeInsets padding;
    BorderRadius borderRadius;

    switch (variant) {
      case OverlayVariant.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        elevation = 4;
        padding = const EdgeInsets.all(16);
        borderRadius = BorderRadius.circular(12);
        break;

      case OverlayVariant.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;
        elevation = 4;
        padding = const EdgeInsets.all(16);
        borderRadius = BorderRadius.circular(12);
        break;

      case OverlayVariant.surface:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        elevation = 4;
        padding = const EdgeInsets.all(16);
        borderRadius = BorderRadius.circular(12);
        break;

      case OverlayVariant.tonal:
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        elevation = 2;
        padding = const EdgeInsets.all(16);
        borderRadius = BorderRadius.circular(12);
        break;

      case OverlayVariant.transparent:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        elevation = 0;
        padding = EdgeInsets.zero;
        borderRadius = BorderRadius.zero;
        break;
    }

    final titleStyle = textTheme.titleMedium?.copyWith(
      color: foregroundColor,
      fontWeight: FontWeight.w600,
    ) ?? const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    final subtitleStyle = textTheme.bodyMedium?.copyWith(
      color: foregroundColor.withOpacity(0.7),
    ) ?? const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );

    return OverlayStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      padding: padding,
      borderRadius: borderRadius,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
    );
  }
}

/// Style configuration for overlays.
@immutable
class OverlayStyle {
  /// The background color of the overlay.
  final Color backgroundColor;

  /// The foreground color (text) of the overlay.
  final Color foregroundColor;

  /// The elevation (shadow depth) of the overlay.
  final double elevation;

  /// The padding inside the overlay.
  final EdgeInsets padding;

  /// The border radius of the overlay.
  final BorderRadius borderRadius;

  /// The text style of the title.
  final TextStyle titleStyle;

  /// The text style of the subtitle.
  final TextStyle subtitleStyle;

  /// Creates a new [OverlayStyle].
  const OverlayStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.elevation,
    required this.padding,
    required this.borderRadius,
    required this.titleStyle,
    required this.subtitleStyle,
  });
}
