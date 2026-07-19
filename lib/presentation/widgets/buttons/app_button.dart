// lib/presentation/widgets/buttons/app_button.dart

import 'package:flutter/material.dart';

import 'enums/app_button_variant.dart';
import 'enums/app_button_size.dart';
import 'enums/app_button_shape.dart';
import 'enums/app_button_width.dart';
import 'builders/button_style_builder.dart';
import 'widgets/button_content.dart';
import 'widgets/button_loading_indicator.dart';
import 'helpers/button_dimensions.dart';
import 'helpers/button_text_style.dart';

/// A customizable application button with multiple variants and sizes.
///
/// This button follows Material Design 3 principles and provides
/// consistent styling across the application. It supports various
/// visual variants, sizes, and states.
///
/// Example:
/// ```dart
/// AppButton(
///   label: 'Submit',
///   onPressed: () => submitForm(),
///   variant: AppButtonVariant.primary,
///   size: AppButtonSize.large,
/// )
/// ```
class AppButton extends StatelessWidget {
  /// The button label text.
  final String label;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// The visual variant of the button.
  final AppButtonVariant variant;

  /// The size of the button.
  final AppButtonSize size;

  /// The shape of the button.
  final AppButtonShape shape;

  /// The width behavior of the button.
  final AppButtonWidth width;

  /// Whether the button is in a loading state.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// Optional icon to display before the label.
  final IconData? leadingIcon;

  /// Optional icon to display after the label.
  final IconData? trailingIcon;

  /// Custom width for the button.
  final double? customWidth;

  /// Custom height for the button.
  final double? customHeight;

  /// Custom padding for the button.
  final EdgeInsetsGeometry? padding;

  /// Border radius for the button.
  final BorderRadiusGeometry? borderRadius;

  /// Creates a new [AppButton].
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.shape = AppButtonShape.rounded,
    this.width = AppButtonWidth.wrap,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.customWidth,
    this.customHeight,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = !isDisabled && onPressed != null;

    final style = ButtonStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
      shape: shape,
      customPadding: padding,
      customBorderRadius: borderRadius,
    );

    final effectiveWidth = _getEffectiveWidth();

    return SizedBox(
      width: effectiveWidth,
      height: customHeight,
      child: _buildButton(
        context,
        isEnabled: isEnabled,
        style: style,
        colorScheme: colorScheme,
      ),
    );
  }

  double? _getEffectiveWidth() {
    if (customWidth != null) return customWidth;
    if (width == AppButtonWidth.full) return double.infinity;
    return null;
  }

  Widget _buildButton(
    BuildContext context, {
    required bool isEnabled,
    required ButtonStyle style,
    required ColorScheme colorScheme,
  }) {
    final child = _buildChild(context, colorScheme);

    switch (variant) {
      case AppButtonVariant.text:
        return TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: style,
          child: child,
        );

      case AppButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: style,
          child: child,
        );

      case AppButtonVariant.tonal:
        return FilledButton.tonal(
          onPressed: isEnabled ? onPressed : null,
          style: style,
          child: child,
        );

      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
      case AppButtonVariant.success:
      case AppButtonVariant.danger:
        return FilledButton(
          onPressed: isEnabled ? onPressed : null,
          style: style,
          child: child,
        );
    }
  }

  Widget _buildChild(BuildContext context, ColorScheme colorScheme) {
    if (isLoading) {
      final foregroundColor = _getLoadingIndicatorColor(colorScheme);
      return ButtonLoadingIndicator(
        color: foregroundColor,
      );
    }

    final textStyle = ButtonTextStyle.getTextStyle(context, size);
    final foregroundColor = _getForegroundColor(colorScheme);

    return ButtonContent(
      label: label,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      textStyle: textStyle.copyWith(color: foregroundColor),
      iconColor: foregroundColor,
      iconSize: ButtonDimensions.getIconSize(size),
    );
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    if (isDisabled) {
      return colorScheme.onSurfaceVariant;
    }

    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
      case AppButtonVariant.tonal:
      case AppButtonVariant.success:
      case AppButtonVariant.danger:
        return colorScheme.onPrimary;
      case AppButtonVariant.outlined:
      case AppButtonVariant.text:
        return colorScheme.primary;
    }
  }

  Color _getLoadingIndicatorColor(ColorScheme colorScheme) {
    // Loading indicator should use the enabled state foreground color
    // since the button is still interactive during loading
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
      case AppButtonVariant.tonal:
      case AppButtonVariant.success:
      case AppButtonVariant.danger:
        return colorScheme.onPrimary;
      case AppButtonVariant.outlined:
      case AppButtonVariant.text:
        return colorScheme.primary;
    }
  }
}
