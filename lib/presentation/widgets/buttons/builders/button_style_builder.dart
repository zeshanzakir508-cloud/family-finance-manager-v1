// lib/presentation/widgets/buttons/builders/button_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/app_button_variant.dart';
import '../enums/app_button_size.dart';
import '../enums/app_button_shape.dart';
import '../constants/button_constants.dart';
import '../helpers/button_dimensions.dart';
import '../helpers/button_padding.dart';
import '../helpers/button_radius.dart';
import '../helpers/button_text_style.dart';

/// Builder class for creating consistent button styles.
///
/// This class constructs platform-appropriate [ButtonStyle] objects
/// based on the provided parameters, using centralized constants and helpers.
///
/// Example:
/// ```dart
/// final style = ButtonStyleBuilder.build(
///   context: context,
///   variant: AppButtonVariant.primary,
///   size: AppButtonSize.medium,
///   shape: AppButtonShape.rounded,
/// );
/// ```
abstract final class ButtonStyleBuilder {
  /// Builds a [ButtonStyle] with the given parameters.
  ///
  /// Parameters:
  ///   - [context]: The build context for accessing theme data.
  ///   - [variant]: The visual variant of the button.
  ///   - [size]: The size of the button.
  ///   - [shape]: The shape/border radius of the button.
  ///   - [customPadding]: Optional custom padding override.
  ///   - [customBorderRadius]: Optional custom border radius override.
  ///
  /// Returns:
  ///   A [ButtonStyle] configured with the given parameters.
  static ButtonStyle build({
    required BuildContext context,
    required AppButtonVariant variant,
    required AppButtonSize size,
    required AppButtonShape shape,
    EdgeInsetsGeometry? customPadding,
    BorderRadiusGeometry? customBorderRadius,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final colors = _getColors(colorScheme, variant);
    final height = ButtonDimensions.getHeight(size);
    final padding = customPadding ?? ButtonPadding.getPadding(size);
    final borderRadius = customBorderRadius ?? ButtonRadius.getRadius(shape);
    final textStyle = ButtonTextStyle.getTextStyle(context, size);

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
          return colors.overlay.withValues(
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
      minimumSize: WidgetStateProperty.all(
        Size(ButtonConstants.minWidth, height),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: _getBorderSide(colorScheme, variant),
        ),
      ),
      textStyle: WidgetStateProperty.all(textStyle),
      animationDuration: ButtonConstants.animationDuration,
    );
  }

  static _ButtonColors _getColors(
    ColorScheme colorScheme,
    AppButtonVariant variant,
  ) {
    switch (variant) {
      case AppButtonVariant.primary:
        return _ButtonColors(
          background: colorScheme.primary,
          foreground: colorScheme.onPrimary,
          overlay: colorScheme.primary.withValues(
            alpha: ButtonConstants.overlayOpacity,
          ),
        );
      case AppButtonVariant.secondary:
        return _ButtonColors(
          background: colorScheme.secondary,
          foreground: colorScheme.onSecondary,
          overlay: colorScheme.secondary.withValues(
            alpha: ButtonConstants.overlayOpacity,
          ),
        );
      case AppButtonVariant.tonal:
        return _ButtonColors(
          background: colorScheme.primaryContainer,
          foreground: colorScheme.onPrimaryContainer,
          overlay: colorScheme.primaryContainer.withValues(
            alpha: ButtonConstants.overlayOpacity,
          ),
        );
      case AppButtonVariant.outlined:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: colorScheme.primary,
          overlay: colorScheme.primary.withValues(
            alpha: ButtonConstants.overlayOpacity,
          ),
        );
      case AppButtonVariant.text:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: colorScheme.primary,
          overlay: colorScheme.primary.withValues(
            alpha: ButtonConstants.overlayOpacity,
          ),
        );
      case AppButtonVariant.danger:
        return _ButtonColors(
          background: colorScheme.error,
          foreground: colorScheme.onError,
          overlay: colorScheme.error.withValues(
            alpha: ButtonConstants.overlayOpacity,
          ),
        );
      case AppButtonVariant.success:
        // Uses primary as success color placeholder until semantic colors are available
        return _ButtonColors(
          background: colorScheme.primary,
          foreground: colorScheme.onPrimary,
          overlay: colorScheme.primary.withValues(
            alpha: ButtonConstants.overlayOpacity,
          ),
        );
    }
  }

  static double _getElevation(AppButtonVariant variant) {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
      case AppButtonVariant.tonal:
      case AppButtonVariant.success:
      case AppButtonVariant.danger:
        return ButtonConstants.elevationDefault;
      case AppButtonVariant.outlined:
      case AppButtonVariant.text:
        return ButtonConstants.elevationNone;
    }
  }

  static BorderSide _getBorderSide(
    ColorScheme colorScheme,
    AppButtonVariant variant,
  ) {
    switch (variant) {
      case AppButtonVariant.outlined:
        return BorderSide(
          color: colorScheme.primary,
          width: ButtonConstants.borderWidthDefault,
        );
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
      case AppButtonVariant.tonal:
      case AppButtonVariant.text:
      case AppButtonVariant.danger:
      case AppButtonVariant.success:
        return BorderSide.none;
    }
  }
}

/// Internal immutable helper class for button colors.
@immutable
class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color overlay;

  const _ButtonColors({
    required this.background,
    required this.foreground,
    required this.overlay,
  });
}
