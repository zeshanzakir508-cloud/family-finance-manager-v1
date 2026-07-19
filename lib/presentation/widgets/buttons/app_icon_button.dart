// lib/presentation/widgets/buttons/app_icon_button.dart

import 'package:flutter/material.dart';

import 'enums/app_icon_button_variant.dart';
import 'enums/app_button_size.dart';
import 'enums/app_button_shape.dart';
import 'builders/icon_button_style_builder.dart';
import 'helpers/button_padding.dart';

/// A customizable icon button with consistent styling.
///
/// This widget provides a standardized icon button that follows the
/// application's design system with support for multiple variants and sizes.
///
/// The icon size is controlled exclusively by the [ButtonStyle] generated
/// by [IconButtonStyleBuilder] based on the [size] parameter.
///
/// Example:
/// ```dart
/// AppIconButton(
///   icon: Icons.favorite,
///   onPressed: () => toggleFavorite(),
///   variant: AppIconButtonVariant.filled,
///   size: AppButtonSize.medium,
/// )
/// ```
class AppIconButton extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// The visual variant of the button.
  final AppIconButtonVariant variant;

  /// The size of the button.
  final AppButtonSize size;

  /// The shape of the button.
  final AppButtonShape shape;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// Custom padding override.
  final EdgeInsetsGeometry? padding;

  /// Custom border radius override.
  final BorderRadiusGeometry? borderRadius;

  /// Tooltip text for the button.
  final String? tooltip;

  /// Creates a new [AppIconButton].
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = AppIconButtonVariant.standard,
    this.size = AppButtonSize.medium,
    this.shape = AppButtonShape.circular,
    this.isDisabled = false,
    this.padding,
    this.borderRadius,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && onPressed != null;

    final style = IconButtonStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
      shape: shape,
      customPadding: padding ?? ButtonPadding.getPadding(size),
      customBorderRadius: borderRadius,
    );

    return IconButton(
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(icon),
      style: style,
      tooltip: tooltip,
      alignment: Alignment.center,
    );
  }
}
