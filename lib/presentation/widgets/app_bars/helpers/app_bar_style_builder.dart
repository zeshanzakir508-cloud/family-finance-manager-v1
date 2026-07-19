import 'package:flutter/material.dart';

import '../enums/app_bar_size.dart';
import '../enums/app_bar_variant.dart';

/// Builds consistent Material 3 app bar styles.
///
/// This class centralizes all reusable styling for application app bars.
abstract final class AppBarStyleBuilder {
  static const double _disabledOpacity = 0.38;

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

    double elevation;
    BorderSide? border;

    switch (variant) {
      case AppBarVariant.filled:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        selectedBackgroundColor = colorScheme.primary;
        selectedForegroundColor = colorScheme.onPrimary;
        disabledBackgroundColor = colorScheme.surfaceContainerHighest;
        disabledForegroundColor =
            colorScheme.onSurface.withValues(alpha: _disabledOpacity);
        elevation = 0;
        border = null;
        break;

      case AppBarVariant.outlined:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        selectedBackgroundColor = colorScheme.primary;
        selectedForegroundColor = colorScheme.onPrimary;
        disabledBackgroundColor = colorScheme.surfaceContainerHighest;
        disabledForegroundColor =
            colorScheme.onSurface.withValues(alpha: _disabledOpacity);
        elevation = 0;
        border = BorderSide(color: colorScheme.outlineVariant);
        break;

      case AppBarVariant.tonal:
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        selectedBackgroundColor = colorScheme.primary;
        selectedForegroundColor = colorScheme.onPrimary;
        disabledBackgroundColor = colorScheme.surfaceContainerHighest;
        disabledForegroundColor =
            colorScheme.onSurface.withValues(alpha: _disabledOpacity);
        elevation = 0;
        border = null;
        break;

      case AppBarVariant.transparent:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        selectedBackgroundColor = Colors.transparent;
        selectedForegroundColor = colorScheme.primary;
        disabledBackgroundColor = Colors.transparent;
        disabledForegroundColor =
            colorScheme.onSurface.withValues(alpha: _disabledOpacity);
        elevation = 0;
        border = null;
        break;
    }

    double toolbarHeight;
    double leadingWidth;
    double titleSpacing;
    double iconSize;
    double actionsSpacing;

    TextStyle titleStyle;
    TextStyle subtitleStyle;

    switch (size) {
      case AppBarSize.compact:
        toolbarHeight = 48;
        leadingWidth = 48;
        titleSpacing = 12;
        iconSize = 20;
        actionsSpacing = 4;
        titleStyle = textTheme.titleMedium!.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        );
        subtitleStyle = textTheme.bodySmall!.copyWith(
          color: foregroundColor.withValues(alpha: 0.8),
        );
        break;

      case AppBarSize.medium:
        toolbarHeight = 56;
        leadingWidth = 56;
        titleSpacing = 16;
        iconSize = 24;
        actionsSpacing = 8;
        titleStyle = textTheme.titleLarge!.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        );
        subtitleStyle = textTheme.bodySmall!.copyWith(
          color: foregroundColor.withValues(alpha: 0.8),
        );
        break;

      case AppBarSize.large:
        toolbarHeight = 64;
        leadingWidth = 64;
        titleSpacing = 20;
        iconSize = 28;
        actionsSpacing = 12;
        titleStyle = textTheme.headlineSmall!.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        );
        subtitleStyle = textTheme.bodyMedium!.copyWith(
          color: foregroundColor.withValues(alpha: 0.8),
        );
        break;
    }

    final shape = RoundedRectangleBorder(
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
      iconSize: iconSize,
      actionsSpacing: actionsSpacing,
      elevation: elevation,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      shape: shape,
    );
  }
}

class AppBarStyle {
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
    required this.iconSize,
    required this.actionsSpacing,
    required this.elevation,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.shape,
  });

  final Color backgroundColor;
  final Color foregroundColor;

  final Color selectedBackgroundColor;
  final Color selectedForegroundColor;

  final Color disabledBackgroundColor;
  final Color disabledForegroundColor;

  final double toolbarHeight;
  final double leadingWidth;
  final double titleSpacing;
  final double iconSize;
  final double actionsSpacing;
  final double elevation;

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  final ShapeBorder shape;

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

class AppBarColors {
  const AppBarColors({
    required this.background,
    required this.foreground,
  });

  final Color background;
  final Color foreground;
}
