// lib/presentation/widgets/chips/app_filter_chip.dart

import 'package:flutter/material.dart';

import 'enums/chip_variant.dart';
import 'enums/chip_size.dart';
import 'helpers/chip_style_builder.dart';

/// A filter chip for selecting/deselecting filter options.
///
/// This widget provides a standardized filter chip that can be toggled
/// on/off, typically used in filter groups.
///
/// Example:
/// ```dart
/// AppFilterChip(
///   label: 'Income',
///   selected: isSelected,
///   onSelected: (value) => setState(() => isSelected = value),
/// )
/// ```
class AppFilterChip extends StatelessWidget {
  /// The label text displayed on the chip.
  final String label;

  /// Whether the chip is selected.
  final bool selected;

  /// Callback when the chip selection changes.
  final ValueChanged<bool>? onSelected;

  /// Optional avatar widget displayed before the label.
  final Widget? avatar;

  /// Whether to show a checkmark when selected.
  final bool showCheckmark;

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

  /// Creates a new [AppFilterChip].
  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.avatar,
    this.showCheckmark = true,
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
      selected: selected,
      disabled: isDisabled,
    );

    final bgColor = backgroundColor ?? colors.background;
    final fgColor = foregroundColor ?? colors.foreground;

    return FilterChip(
      label: Text(
        label,
        style: style.textStyle.copyWith(
          color: fgColor,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      selected: selected,
      onSelected: isDisabled ? null : onSelected,
      avatar: avatar != null
          ? IconTheme(
              data: IconThemeData(
                color: fgColor,
                size: style.iconSize,
              ),
              child: avatar!,
            )
          : null,
      backgroundColor: bgColor,
      selectedColor: style.selectedBackgroundColor,
      labelStyle: style.textStyle.copyWith(color: fgColor),
      padding: style.padding,
      shape: shape ?? style.shape,
      elevation: 0,
      pressElevation: 0,
      side: isDisabled
          ? BorderSide.none
          : border ?? style.border ?? BorderSide.none,
      showCheckmark: showCheckmark,
      checkmarkColor: style.selectedForegroundColor,
    );
  }
}
