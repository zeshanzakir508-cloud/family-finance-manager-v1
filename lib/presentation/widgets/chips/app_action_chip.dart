// lib/presentation/widgets/chips/app_action_chip.dart

import 'package:flutter/material.dart';

import 'enums/chip_variant.dart';
import 'enums/chip_size.dart';
import 'helpers/chip_style_builder.dart';

/// An action chip for performing an action.
///
/// This widget provides a standardized action chip that follows the
/// application's design system with consistent styling.
///
/// Example:
/// ```dart
/// AppActionChip(
///   label: 'Add Category',
///   avatar: Icon(Icons.add),
///   onPressed: () => addCategory(),
/// )
/// ```
class AppActionChip extends StatelessWidget {
  /// The label text displayed on the chip.
  final String label;

  /// Optional avatar widget displayed before the label.
  final Widget? avatar;

  /// Optional trailing icon widget.
  final Widget? trailingIcon;

  /// Callback when the chip is pressed.
  final VoidCallback? onPressed;

  /// Callback when the chip is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether the chip is disabled.
  final bool isDisabled;

  /// The visual variant of the chip.
  final ChipVariant variant;

  /// The size of the chip.
  final ChipSize size;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Custom padding override.
  final EdgeInsetsGeometry? padding;

  /// Custom shape override.
  final ShapeBorder? shape;

  /// Custom border override.
  final BorderSide? border;

  /// Creates a new [AppActionChip].
  const AppActionChip({
    super.key,
    required this.label,
    this.avatar,
    this.trailingIcon,
    this.onPressed,
    this.onLongPress,
    this.isDisabled = false,
    this.variant = ChipVariant.filled,
    this.size = ChipSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.shape,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final style = ChipStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
    );

    final effectivePadding = padding ?? style.padding;
    final effectiveShape = shape ?? style.shape;

    final colors = style.resolve(
      selected: false,
      disabled: isDisabled,
    );

    final bgColor = backgroundColor ?? colors.background;
    final fgColor = foregroundColor ?? colors.foreground;

    // Build chip content
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (avatar != null) ...[
          IconTheme(
            data: IconThemeData(
              color: fgColor,
              size: style.iconSize,
            ),
            child: avatar!,
          ),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: style.textStyle.copyWith(color: fgColor),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 4),
          IconTheme(
            data: IconThemeData(
              color: fgColor,
              size: style.iconSize,
            ),
            child: trailingIcon!,
          ),
        ],
      ],
    );

    return ActionChip(
      label: content,
      onPressed: isDisabled ? null : onPressed,
      onLongPress: isDisabled ? null : onLongPress,
      backgroundColor: bgColor,
      labelStyle: style.textStyle.copyWith(color: fgColor),
      padding: effectivePadding,
      shape: effectiveShape,
      elevation: 0,
      pressElevation: 0,
      side: isDisabled
          ? BorderSide.none
          : border ?? style.border ?? BorderSide.none,
    );
  }
}
