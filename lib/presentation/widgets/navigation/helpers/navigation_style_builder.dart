// lib/presentation/widgets/navigation/helpers/navigation_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/navigation_variant.dart';
import '../enums/navigation_size.dart';

/// Builder class for creating consistent navigation styles.
///
/// This class constructs [NavigationStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for navigation styling.
///
/// Example:
/// ```dart
/// final style = NavigationStyleBuilder.build(
///   context: context,
///   variant: NavigationVariant.primary,
///   size: NavigationSize.medium,
/// );
///
/// final colors = style.resolve(
///   selected: true,
///   disabled: false,
/// );
/// ```
abstract final class NavigationStyleBuilder {
  static const double _disabledOpacity = 0.38;

  /// Builds a [NavigationStyle] configuration with the given parameters.
  static NavigationStyle build({
    required BuildContext context,
    required NavigationVariant variant,
    required NavigationSize size,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Color backgroundColor;
    Color foregroundColor;
    Color selectedBackgroundColor;
    Color selectedForegroundColor;
    Color disabledBackgroundColor;
    Color disabledForegroundColor;
    Color indicatorColor;
    BorderSide? border;
    double elevation;
    double borderRadius;
    double iconSize;
    double labelSpacing;
    EdgeInsets labelPadding;
    TextStyle labelStyle;
    TextStyle selectedLabelStyle;

    // -------------------------------------------------------------------------
    // Variant-based styling
    // -------------------------------------------------------------------------
    switch (variant) {
      case NavigationVariant.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        selectedBackgroundColor = colorScheme.primaryContainer;
        selectedForegroundColor = colorScheme.onPrimaryContainer;
        disabledBackgroundColor = colorScheme.primary.withOpacity(
          _disabledOpacity,
        );
        disabledForegroundColor = colorScheme.onPrimary.withOpacity(
          _disabledOpacity,
        );
        indicatorColor = colorScheme.onPrimaryContainer;
        border = null;
        elevation = 0;
        borderRadius = 0;
        break;

      case NavigationVariant.secondary:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        selectedBackgroundColor = colorScheme.secondaryContainer;
        selectedForegroundColor = colorScheme.onSecondaryContainer;
        disabledBackgroundColor = colorScheme.surface.withOpacity(
          _disabledOpacity,
        );
        disabledForegroundColor = colorScheme.onSurface.withOpacity(
          _disabledOpacity,
        );
        indicatorColor = colorScheme.secondary;
        border = BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        );
        elevation = 1;
        borderRadius = 0;
        break;

      case NavigationVariant.surface:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        selectedBackgroundColor = colorScheme.surfaceContainerHighest;
        selectedForegroundColor = colorScheme.onSurface;
        disabledBackgroundColor = colorScheme.surface.withOpacity(
          _disabledOpacity,
        );
        disabledForegroundColor = colorScheme.onSurface.withOpacity(
          _disabledOpacity,
        );
        indicatorColor = colorScheme.primary;
        border = null;
        elevation = 2;
        borderRadius = 0;
        break;

      case NavigationVariant.tonal:
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        selectedBackgroundColor = colorScheme.primaryContainer;
        selectedForegroundColor = colorScheme.onPrimaryContainer;
        disabledBackgroundColor = colorScheme.secondaryContainer.withOpacity(
          _disabledOpacity,
        );
        disabledForegroundColor = colorScheme.onSecondaryContainer.withOpacity(
          _disabledOpacity,
        );
        indicatorColor = colorScheme.primary;
        border = null;
        elevation = 0;
        borderRadius = 0;
        break;
    }

    // -------------------------------------------------------------------------
    // Size-based styling
    // -------------------------------------------------------------------------
    switch (size) {
      case NavigationSize.compact:
        iconSize = 20;
        labelSpacing = 4;
        labelPadding = const EdgeInsets.symmetric(horizontal: 4);
        labelStyle = textTheme.labelSmall?.copyWith(
          color: foregroundColor,
        ) ?? const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        );
        selectedLabelStyle = textTheme.labelSmall?.copyWith(
          color: selectedForegroundColor,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        );
        borderRadius = 8;
        break;

      case NavigationSize.medium:
        iconSize = 24;
        labelSpacing = 6;
        labelPadding = const EdgeInsets.symmetric(horizontal: 8);
        labelStyle = textTheme.labelMedium?.copyWith(
          color: foregroundColor,
        ) ?? const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        );
        selectedLabelStyle = textTheme.labelMedium?.copyWith(
          color: selectedForegroundColor,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
        borderRadius = 12;
        break;

      case NavigationSize.large:
        iconSize = 28;
        labelSpacing = 8;
        labelPadding = const EdgeInsets.symmetric(horizontal: 12);
        labelStyle = textTheme.labelLarge?.copyWith(
          color: foregroundColor,
        ) ?? const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        );
        selectedLabelStyle = textTheme.labelLarge?.copyWith(
          color: selectedForegroundColor,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        );
        borderRadius = 16;
        break;
    }

    // -------------------------------------------------------------------------
    // Shape
    // -------------------------------------------------------------------------
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: border ?? BorderSide.none,
    );

    return NavigationStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      selectedForegroundColor: selectedForegroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      indicatorColor: indicatorColor,
      iconSize: iconSize,
      labelSpacing: labelSpacing,
      labelPadding: labelPadding,
      labelStyle: labelStyle,
      selectedLabelStyle: selectedLabelStyle,
      elevation: elevation,
      shape: shape,
      border: border,
    );
  }
}

/// Style configuration for navigation components.
///
/// Contains all visual properties needed to style navigation consistently.
@immutable
class NavigationStyle {
  /// The background color of the navigation.
  final Color backgroundColor;

  /// The foreground color (text/icon) of the navigation.
  final Color foregroundColor;

  /// The background color when selected.
  final Color selectedBackgroundColor;

  /// The foreground color when selected.
  final Color selectedForegroundColor;

  /// The background color when disabled.
  final Color disabledBackgroundColor;

  /// The foreground color when disabled.
  final Color disabledForegroundColor;

  /// The color of the selection indicator.
  final Color indicatorColor;

  /// The size of icons in the navigation.
  final double iconSize;

  /// The spacing between icon and label.
  final double labelSpacing;

  /// The padding around the label.
  final EdgeInsets labelPadding;

  /// The text style of the label.
  final TextStyle labelStyle;

  /// The text style of the selected label.
  final TextStyle selectedLabelStyle;

  /// The elevation (shadow depth) of the navigation.
  final double elevation;

  /// The shape (including border radius and border) of the navigation.
  final ShapeBorder shape;

  /// The border of the navigation, if any.
  final BorderSide? border;

  /// Creates a new [NavigationStyle].
  const NavigationStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.selectedBackgroundColor,
    required this.selectedForegroundColor,
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.indicatorColor,
    required this.iconSize,
    required this.labelSpacing,
    required this.labelPadding,
    required this.labelStyle,
    required this.selectedLabelStyle,
    required this.elevation,
    required this.shape,
    this.border,
  });

  /// Resolves the appropriate colors based on the navigation's state.
  ///
  /// Parameters:
  ///   - [selected]: Whether the navigation is selected.
  ///   - [disabled]: Whether the navigation is disabled.
  ///
  /// Returns:
  ///   A [NavigationColors] object containing the resolved background and
  ///   foreground colors.
  NavigationColors resolve({
    required bool selected,
    required bool disabled,
  }) {
    if (disabled) {
      return NavigationColors(
        background: disabledBackgroundColor,
        foreground: disabledForegroundColor,
      );
    }

    if (selected) {
      return NavigationColors(
        background: selectedBackgroundColor,
        foreground: selectedForegroundColor,
      );
    }

    return NavigationColors(
      background: backgroundColor,
      foreground: foregroundColor,
    );
  }
}

/// Resolved colors for navigation based on its state.
@immutable
class NavigationColors {
  /// The background color of the navigation.
  final Color background;

  /// The foreground color (text/icon) of the navigation.
  final Color foreground;

  /// Creates a new [NavigationColors].
  const NavigationColors({
    required this.background,
    required this.foreground,
  });
}
