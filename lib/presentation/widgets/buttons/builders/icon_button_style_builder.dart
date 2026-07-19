// lib/presentation/widgets/buttons/builders/icon_button_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/app_icon_button_variant.dart';
import '../enums/app_button_size.dart';
import '../enums/app_button_shape.dart';
import '../constants/button_constants.dart';
import '../helpers/button_dimensions.dart';
import '../helpers/button_radius.dart';

/// Builder class for creating consistent icon button styles.
///
/// This class constructs [ButtonStyle] objects for icon buttons
/// based on the provided parameters, using centralized constants and helpers.
///
/// Example:
/// ```dart
/// final style = IconButtonStyleBuilder.build(
///   context: context,
///   variant: AppIconButtonVariant.filled,
///   size: AppButtonSize.medium,
///   shape: AppButtonShape.circular,
/// );
/// ```
abstract final class IconButtonStyleBuilder {
  /// Builds a [ButtonStyle] for an icon button with the given parameters.
  ///
  /// Parameters:
  ///   - [context]: The build context for accessing theme data.
  ///   - [variant]: The visual variant of the icon button.
  ///   - [size]: The size of the icon button.
  ///   - [shape]: The shape/border radius of the icon button.
  ///   - [customPadding]: Optional custom padding override.
  ///   - [customBorderRadius]: Optional custom border radius override.
  ///
  /// Returns:
  ///   A [ButtonStyle] configured for an icon button.
  static ButtonStyle build({
    required BuildContext context,
    required AppIconButtonVariant variant,
    required AppButtonSize size,
    required AppButtonShape shape,
    EdgeInsetsGeometry? customPadding,
    BorderRadiusGeometry? customBorderRadius,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final colors = _getColors(colorScheme, variant);
    final iconSize = ButtonDimensions.getIconSize(size);
    final padding = customPadding ?? _getPadding(size);
    final borderRadius = customBorderRadius ?? ButtonRadius.getRadius(shape);
    final dimension = ButtonDimensions.getHeight(size);

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.surfaceVariant.withValues(
            alpha: ButtonConstants.disabledContainerOpacity,
          );
        }
        return colors.background;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurfaceVariant.withValues(
            alpha: ButtonConstants.disabledOpacity,
          );
        }
        return colors.foreground;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }
        if (states.contains(WidgetState.pressed)) {
          return colors.overlay;
        }
        if (states.contains(WidgetState.hovered)) {
          return colors.overlay?.withValues(
            alpha: ButtonConstants.hoverOverlayOpacity,
          );
        }
        return Colors.transparent;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return ButtonConstants.elevationNone;
        }
        return _getElevation(variant);
      }),
      padding: WidgetStateProperty.all(padding),
      minimumSize: WidgetStateProperty.all(Size(dimension, dimension)),
      maximumSize: WidgetStateProperty.all(Size(dimension, dimension)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: _getBorderSide(colorScheme, variant),
        ),
      ),
      iconSize: WidgetStateProperty.all(iconSize),
      animationDuration: ButtonConstants.animationDuration,
    );
  }

  static _IconButtonColors _getColors(
    ColorScheme colorScheme,
    AppIconButtonVariant variant,
  ) {
    switch (variant) {
      case AppIconButtonVariant.standard:
        return _IconButtonColors(
          background: Colors.transparent,
          foreground: colorScheme.onSurfaceVariant,
          overlay: colorScheme.onSurfaceVariant.withValues(
            alpha: ButtonConstants.overlayOpacity,
          ),
        );
      case AppIconButtonVariant.filled:
        return _IconButtonColors(
          background: colorScheme.primary,
          foreground: colorScheme.onPrimary,
          overlay: colorScheme.primary.withValues(
            alpha: ButtonConstants.overlayOpacity,
          ),
        );
      case AppIconButtonVariant.filledTonal:
        return _IconButtonColors(
          background: colorScheme.primaryContainer,
          foreground: colorScheme.onPrimaryContainer,
          overlay: colorScheme.primaryContainer.withValues(
            alpha: ButtonConstants.overlayOpacity,
          ),
        );
      case AppIconButtonVariant.outlined:
        return _IconButtonColors(
          background: Colors.transparent,
          foreground: colorScheme.primary,
          overlay: colorScheme.primary.withValues(
            alpha: ButtonConstants.overlayOpacity,
          ),
        );
    }
  }

  static double _getElevation(AppIconButtonVariant variant) {
    switch (variant) {
      case AppIconButtonVariant.filled:
      case AppIconButtonVariant.filledTonal:
        return ButtonConstants.elevationDefault;
      case AppIconButtonVariant.standard:
      case AppIconButtonVariant.outlined:
        return ButtonConstants.elevationNone;
    }
  }

  static EdgeInsetsGeometry _getPadding(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.extraSmall:
        return EdgeInsets.all(ButtonConstants.paddingVerticalExtraSmall);
      case AppButtonSize.small:
        return EdgeInsets.all(ButtonConstants.paddingVerticalSmall);
      case AppButtonSize.medium:
        return EdgeInsets.all(ButtonConstants.paddingVerticalMedium);
      case AppButtonSize.large:
        return EdgeInsets.all(ButtonConstants.paddingVerticalLarge);
      case AppButtonSize.extraLarge:
        return EdgeInsets.all(ButtonConstants.paddingVerticalExtraLarge);
    }
  }

  static BorderSide _getBorderSide(
    ColorScheme colorScheme,
    AppIconButtonVariant variant,
  ) {
    switch (variant) {
      case AppIconButtonVariant.outlined:
        return BorderSide(
          color: colorScheme.primary,
          width: ButtonConstants.borderWidthDefault,
        );
      case AppIconButtonVariant.standard:
      case AppIconButtonVariant.filled:
      case AppIconButtonVariant.filledTonal:
        return BorderSide.none;
    }
  }
}

/// Internal immutable helper class for icon button colors.
@immutable
class _IconButtonColors {
  final Color background;
  final Color foreground;
  final Color? overlay;

  const _IconButtonColors({
    required this.background,
    required this.foreground,
    this.overlay,
  });
}
