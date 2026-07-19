// lib/presentation/widgets/buttons/builders/toggle_button_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/app_button_size.dart';
import '../enums/app_button_shape.dart';
import '../constants/button_constants.dart';
import '../helpers/button_dimensions.dart';
import '../helpers/button_padding.dart';
import '../helpers/button_radius.dart';
import '../helpers/button_text_style.dart';

/// Builder class for creating consistent toggle button styles.
///
/// This class constructs [ButtonStyle] objects for toggle buttons
/// based on the provided parameters, using centralized constants and helpers.
///
/// Example:
/// ```dart
/// final style = ToggleButtonStyleBuilder.build(
///   context: context,
///   size: AppButtonSize.medium,
/// );
/// ```
abstract final class ToggleButtonStyleBuilder {
  /// Builds a [ButtonStyle] for a toggle button with the given parameters.
  ///
  /// Parameters:
  ///   - [context]: The build context for accessing theme data.
  ///   - [size]: The size of the toggle button.
  ///   - [customPadding]: Optional custom padding override.
  ///   - [customBorderRadius]: Optional custom border radius override.
  ///
  /// Returns:
  ///   A [ButtonStyle] configured for a toggle button.
  static ButtonStyle build({
    required BuildContext context,
    required AppButtonSize size,
    EdgeInsetsGeometry? customPadding,
    BorderRadiusGeometry? customBorderRadius,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final height = ButtonDimensions.getHeight(size);
    final padding = customPadding ?? ButtonPadding.getPadding(size);
    final borderRadius = customBorderRadius ??
        ButtonRadius.getRadius(AppButtonShape.rounded);
    final textStyle = ButtonTextStyle.getTextStyle(context, size);

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.surfaceVariant.withValues(
            alpha: ButtonConstants.disabledContainerOpacity,
          );
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurfaceVariant.withValues(
            alpha: ButtonConstants.disabledOpacity,
          );
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.onSurface;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary.withValues(
            alpha: ButtonConstants.overlayOpacity,
          );
        }
        if (states.contains(WidgetState.pressed)) {
          return colorScheme.onSurface.withValues(
            alpha: ButtonConstants.overlayOpacity,
          );
        }
        if (states.contains(WidgetState.hovered)) {
          return colorScheme.onSurface.withValues(
            alpha: ButtonConstants.hoverOverlayOpacity,
          );
        }
        return Colors.transparent;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return ButtonConstants.elevationNone;
        }
        if (states.contains(WidgetState.selected)) {
          return ButtonConstants.elevationDefault;
        }
        return ButtonConstants.elevationNone;
      }),
      padding: WidgetStateProperty.all(padding),
      minimumSize: WidgetStateProperty.all(
        Size(ButtonConstants.minWidth, height),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
      textStyle: WidgetStateProperty.all(textStyle),
      animationDuration: ButtonConstants.animationDuration,
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return BorderSide(
            color: colorScheme.primary,
            width: ButtonConstants.borderWidthDefault,
          );
        }
        return BorderSide(
          color: colorScheme.outlineVariant,
          width: ButtonConstants.borderWidthDefault,
        );
      }),
    );
  }
}
