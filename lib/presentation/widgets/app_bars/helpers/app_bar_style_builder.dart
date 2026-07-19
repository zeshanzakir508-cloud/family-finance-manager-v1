// lib/presentation/widgets/app_bars/helpers/app_bar_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/app_bar_variant.dart';
import '../enums/app_bar_size.dart';

/// Builder class for creating consistent app bar styles.
///
/// This class constructs [AppBarStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for app bar styling.
///
/// Example:
/// ```dart
/// final style = AppBarStyleBuilder.build(
///   context: context,
///   variant: AppBarVariant.primary,
///   size: AppBarSize.medium,
/// );
///
/// final colors = style.resolve(
///   selected: true,
///   disabled: false,
/// );
/// ```
abstract final class AppBarStyleBuilder {
  static const double _disabledOpacity = 0.38;

  /// Builds an [AppBarStyle] configuration with the given parameters.
  static AppBarStyle build({
    required BuildContext context,
    required AppBarVariant variant,
    required AppBarSize size,
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
    BorderSide? border;
    double elevation;
    BorderRadius borderRadius;
    TextStyle titleStyle;
    TextStyle subtitleStyle;
    double leadingWidth;
    double titleSpacing;
    double iconSize;
    double actionsSpacing;
    double toolbarHeight;
    EdgeInsets titlePadding;

    // -------------------------------------------------------------------------
    // Variant-based styling
    // -------------------------------------------------------------------------
    switch (variant) {
      case AppBarVariant.primary:
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
        border = null;
        elevation = 0;
        borderRadius = BorderRadius.zero;
        break;

      case AppBarVariant.secondary:
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
        border = BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        );
        elevation = 0;
        borderRadius = BorderRadius.zero;
        break;

      case AppBarVariant.surface:
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
        border = null;
        elevation = 2;
        borderRadius = BorderRadius.zero;
        break;

      case AppBarVariant.elevated:
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
        border = null;
        elevation = 4;
        borderRadius = BorderRadius.zero;
        break;

      case AppBarVariant.transparent:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        selectedBackgroundColor = colorScheme.surface.withOpacity(0.8);
        selectedForegroundColor = colorScheme.onSurface;
        disabledBackgroundColor = Colors.transparent;
        disabledForegroundColor = colorScheme.onSurface.withOpacity(
          _disabledOpacity,
        );
        border = null;
        elevation = 0;
        borderRadius = BorderRadius.zero;
        break;

      case AppBarVariant.rounded:
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
        border = null;
        elevation = 2;
        borderRadius = BorderRadius.circular(16);
        break;
    }

    // -------------------------------------------------------------------------
    // Size-based styling
    // -------------------------------------------------------------------------
    toolbarHeight = size.toolbarHeight;

    switch (size) {
      case AppBarSize.compact:
        leadingWidth = 48;
        titleSpacing = 12;
        iconSize = 20;
        actionsSpacing = 8;
        titlePadding = const EdgeInsets.symmetric(horizontal: 8);
        titleStyle = textTheme.titleMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w500,
        ) ?? const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        );
        subtitleStyle = textTheme.bodySmall?.copyWith(
          color: foregroundColor.withOpacity(0.7),
        ) ?? const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        );
        break;

      case AppBarSize.medium:
        leadingWidth = 56;
        titleSpacing = 16;
        iconSize = 24;
        actionsSpacing = 12;
        titlePadding = const EdgeInsets.symmetric(horizontal: 12);
        titleStyle = textTheme.titleLarge?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        );
        subtitleStyle = textTheme.bodyMedium?.copyWith(
          color: foregroundColor.withOpacity(0.7),
        ) ?? const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        );
        break;

      case AppBarSize.large:
        leadingWidth = 64;
        titleSpacing = 20;
        iconSize = 28;
        actionsSpacing = 16;
        titlePadding = const EdgeInsets.symmetric(horizontal: 16);
        titleStyle = textTheme.headlineSmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        );
        subtitleStyle = textTheme.titleSmall?.copyWith(
          color: foregroundColor.withOpacity(0.7),
        ) ?? const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        );
        break;
    }

    // -------------------------------------------------------------------------
    // Shape
    // -------------------------------------------------------------------------
    final shape = RoundedRectangleBorder(
      borderRadius: borderRadius,
      side: border ?? BorderSide.none,
    );

    return AppBarStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      selectedForegroundColor: selectedForegroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      titleSpacing: titleSpacing,
      titlePadding: titlePadding,
      iconSize: iconSize,
      actionsSpacing: actionsSpacing,
      elevation: elevation,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      shape: shape,
    );
  }
}

/// Style configuration for app bars.
///
/// Contains all visual properties needed to style an app bar consistently.
@immutable
class AppBarStyle {
  /// The background color of the app bar.
  final Color backgroundColor;

  /// The foreground color (text/icon) of the app bar.
  final Color foregroundColor;

  /// The background color when selected.
  final Color selectedBackgroundColor;

  /// The foreground color when selected.
  final Color selectedForegroundColor;

  /// The background color when disabled.
  final Color disabledBackgroundColor;

  /// The foreground color when disabled.
  final Color disabledForegroundColor;

  /// The height of the app bar toolbar.
  final double toolbarHeight;

  /// The width of the leading widget area.
  final double leadingWidth;

  /// The spacing between the leading and title.
  final double titleSpacing;

  /// The padding around the title.
  final EdgeInsets titlePadding;

  /// The size of icons in the app bar.
  final double iconSize;

  /// The spacing between action widgets.
  final double actionsSpacing;

  /// The elevation (shadow depth) of the app bar.
  final double elevation;

  /// The text style of the title.
  final TextStyle titleStyle;

  /// The text style of the subtitle.
  final TextStyle subtitleStyle;

  /// The shape (including border radius and border) of the app bar.
  final ShapeBorder shape;

  /// Creates a new [AppBarStyle].
  const AppBarStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.selectedBackgroundColor,
    required this.selectedForegroundColor,
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.toolbarHeight,
    required this.leadingWidth,
    required this.titleSpacing,
    required this.titlePadding,
    required this.iconSize,
    required this.actionsSpacing,
    required this.elevation,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.shape,
  });

  /// Resolves the appropriate colors based on the app bar's state.
  ///
  /// Parameters:
  ///   - [selected]: Whether the app bar is selected.
  ///   - [disabled]: Whether the app bar is disabled.
  ///
  /// Returns:
  ///   An [AppBarColors] object containing the resolved background and
  ///   foreground colors.
  AppBarColors resolve({
    required bool selected,
    required bool disabled,
  }) {
    if (disabled) {
      return AppBarColors(
        background: disabledBackgroundColor,
        foreground: disabledForegroundColor,
      );
    }

    if (selected) {
      return AppBarColors(
        background: selectedBackgroundColor,
        foreground: selectedForegroundColor,
      );
    }

    return AppBarColors(
      background: backgroundColor,
      foreground: foregroundColor,
    );
  }
}

/// Resolved colors for an app bar based on its state.
@immutable
class AppBarColors {
  /// The background color of the app bar.
  final Color background;

  /// The foreground color (text/icon) of the app bar.
  final Color foreground;

  /// Creates a new [AppBarColors].
  const AppBarColors({
    required this.background,
    required this.foreground,
  });
}
