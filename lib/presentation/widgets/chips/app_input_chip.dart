// lib/presentation/widgets/chips/app_input_chip.dart

import 'package:flutter/material.dart';

import 'enums/chip_variant.dart';
import 'enums/chip_size.dart';
import 'helpers/chip_style_builder.dart';

/// An input chip for removable items like tags and keywords.
///
/// This widget provides a standardized input chip with a delete button
/// for removing items from a collection.
///
/// Example:
/// ```dart
/// AppInputChip(
///   label: 'Flutter',
///   onDeleted: () => removeTag('Flutter'),
///   avatar: Icon(Icons.tag),
/// )
/// ```
class AppInputChip extends StatelessWidget {
  /// The label text displayed on the chip.
  final String label;

  /// Callback when the delete icon is pressed.
  final VoidCallback? onDeleted;

  /// Optional avatar widget displayed before the label.
  final Widget? avatar;

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

  /// Custom shape override.
  final ShapeBorder? shape;

  /// Custom border override.
  final BorderSide? border;

  /// Creates a new [AppInputChip].
  const AppInputChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.avatar,
    this.isDisabled = false,
    this.variant = ChipVariant.filled,
    this.size = ChipSize.medium,
    this.backgroundColor,
    this.foregroundColor,
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

    final colors = style.resolve(
      selected: false,
      disabled: isDisabled,
    );

    final bgColor = backgroundColor ?? colors.background;
    final fgColor = foregroundColor ?? colors.foreground;

    return InputChip(
      label: Text(
        label,
        style: style.textStyle.copyWith(color: fgColor),
      ),
      avatar: avatar != null
          ? IconTheme(
              data: IconThemeData(
                color: fgColor,
                size: style.iconSize,
              ),
              child: avatar!,
            )
          : null,
      onDeleted: isDisabled ? null : onDeleted,
      backgroundColor: bgColor,
      labelStyle: style.textStyle.copyWith(color: fgColor),
      padding: style.padding,
      shape: shape ?? style.shape,
      elevation: 0,
      pressElevation: 0,
      side: isDisabled
          ? BorderSide.none
          : border ?? style.border ?? BorderSide.none,
      deleteIconColor: fgColor,
      deleteIconSize: style.deleteIconSize,
    );
  }
}
