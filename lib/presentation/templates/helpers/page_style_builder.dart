// lib/presentation/templates/helpers/page_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/page_density.dart';
import '../enums/page_variant.dart';

/// Builder class for creating consistent page styles.
///
/// This class constructs [PageStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for page styling.
///
/// Example:
/// ```dart
/// final style = PageStyleBuilder.build(
///   context: context,
///   variant: PageVariant.standard,
///   density: PageDensity.comfortable,
/// );
/// ```
abstract final class PageStyleBuilder {
  /// Builds a [PageStyle] configuration with the given parameters.
  static PageStyle build({
    required BuildContext context,
    required PageVariant variant,
    required PageDensity density,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    EdgeInsets padding;
    double spacing;

    switch (variant) {
      case PageVariant.standard:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        break;
      case PageVariant.filled:
        backgroundColor = colorScheme.surfaceContainerLow;
        foregroundColor = colorScheme.onSurface;
        break;
      case PageVariant.gradient:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        break;
      case PageVariant.transparent:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        break;
    }

    switch (density) {
      case PageDensity.compact:
        padding = const EdgeInsets.all(12);
        spacing = 12;
        break;
      case PageDensity.comfortable:
        padding = const EdgeInsets.all(16);
        spacing = 16;
        break;
      case PageDensity.spacious:
        padding = const EdgeInsets.all(24);
        spacing = 24;
        break;
    }

    return PageStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: padding,
      spacing: spacing,
    );
  }
}

/// Style configuration for pages.
@immutable
class PageStyle {
  /// The background color of the page.
  final Color backgroundColor;

  /// The foreground color (text) of the page.
  final Color foregroundColor;

  /// The padding inside the page.
  final EdgeInsets padding;

  /// The spacing between page elements.
  final double spacing;

  /// Creates a new [PageStyle].
  const PageStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.padding,
    required this.spacing,
  });
}
