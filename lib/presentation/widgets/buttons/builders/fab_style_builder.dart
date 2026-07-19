// lib/presentation/widgets/buttons/builders/fab_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/app_fab_size.dart';
import '../constants/button_constants.dart';

/// Builder class for creating consistent Floating Action Button styles.
///
/// This class constructs [ButtonStyle] objects for FABs
/// based on the provided parameters, using centralized constants.
///
/// Example:
/// ```dart
/// final style = FabStyleBuilder.build(
///   context: context,
///   size: AppFabSize.regular,
///   backgroundColor: Colors.blue,
///   foregroundColor: Colors.white,
/// );
/// ```
abstract final class FabStyleBuilder {
  /// Builds a [ButtonStyle] for a FAB with the given parameters.
  ///
  /// Parameters:
  ///   - [context]: The build context for accessing theme data.
  ///   - [size]: The size of the FAB.
  ///   - [backgroundColor]: Optional custom background color.
  ///   - [foregroundColor]: Optional custom foreground color.
  ///   - [elevation]: Optional custom elevation.
  ///   - [shape]: Optional custom shape.
  ///
  /// Returns:
  ///   A [ButtonStyle] configured for a FAB.
  static ButtonStyle build({
    required BuildContext context,
    required AppFabSize size,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = backgroundColor ?? colorScheme.primary;
    final fgColor = foregroundColor ?? colorScheme.onPrimary;
    final fabElevation = elevation ?? _getElevation(size);
    final fabShape = shape ?? _getShape(size);
    final fabSize = _getSize(size);

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.surfaceVariant.withValues(
            alpha: ButtonConstants.disabledContainerOpacity,
          );
        }
        return bgColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurfaceVariant.withValues(
            alpha: ButtonConstants.disabledOpacity,
          );
        }
        return fgColor;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }
        if (states.contains(WidgetState.pressed)) {
          return bgColor.withValues(alpha: ButtonConstants.overlayOpacity);
        }
        if (states.contains(WidgetState.hovered)) {
          return bgColor.withValues(alpha: ButtonConstants.hoverOverlayOpacity);
        }
        return Colors.transparent;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return ButtonConstants.elevationNone;
        }
        return fabElevation;
      }),
      padding: WidgetStateProperty.all(_getPadding(size)),
      minimumSize: WidgetStateProperty.all(fabSize),
      maximumSize: WidgetStateProperty.all(fabSize),
      shape: WidgetStateProperty.all(fabShape),
      iconSize: WidgetStateProperty.all(_getIconSize(size)),
      animationDuration: ButtonConstants.animationDuration,
    );
  }

  static double _getElevation(AppFabSize size) {
    switch (size) {
      case AppFabSize.small:
      case AppFabSize.regular:
      case AppFabSize.large:
        return ButtonConstants.elevationDefault;
      case AppFabSize.extended:
        return ButtonConstants.elevationElevated;
    }
  }

  static ShapeBorder _getShape(AppFabSize size) {
    switch (size) {
      case AppFabSize.small:
      case AppFabSize.regular:
      case AppFabSize.large:
        return const CircleBorder();
      case AppFabSize.extended:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ButtonConstants.fabExtendedRadius),
        );
    }
  }

  static Size _getSize(AppFabSize size) {
    switch (size) {
      case AppFabSize.small:
        return Size(
          ButtonConstants.fabSizeSmall,
          ButtonConstants.fabSizeSmall,
        );
      case AppFabSize.regular:
        return Size(
          ButtonConstants.fabSizeRegular,
          ButtonConstants.fabSizeRegular,
        );
      case AppFabSize.large:
        return Size(
          ButtonConstants.fabSizeLarge,
          ButtonConstants.fabSizeLarge,
        );
      case AppFabSize.extended:
        return Size(
          ButtonConstants.fabExtendedMinWidth,
          ButtonConstants.fabExtendedHeight,
        );
    }
  }

  static EdgeInsetsGeometry _getPadding(AppFabSize size) {
    switch (size) {
      case AppFabSize.small:
        return EdgeInsets.all(ButtonConstants.fabPaddingSmall);
      case AppFabSize.regular:
        return EdgeInsets.all(ButtonConstants.fabPaddingRegular);
      case AppFabSize.large:
        return EdgeInsets.all(ButtonConstants.fabPaddingLarge);
      case AppFabSize.extended:
        return EdgeInsets.symmetric(
          horizontal: ButtonConstants.fabExtendedPaddingHorizontal,
          vertical: ButtonConstants.fabExtendedPaddingVertical,
        );
    }
  }

  static double _getIconSize(AppFabSize size) {
    switch (size) {
      case AppFabSize.small:
        return ButtonConstants.fabIconSizeSmall;
      case AppFabSize.regular:
        return ButtonConstants.fabIconSizeRegular;
      case AppFabSize.large:
        return ButtonConstants.fabIconSizeLarge;
      case AppFabSize.extended:
        return ButtonConstants.fabIconSizeRegular;
    }
  }
}
