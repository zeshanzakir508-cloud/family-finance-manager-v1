// lib/presentation/widgets/chips/helpers/chip_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/chip_variant.dart';
import '../enums/chip_size.dart';

/// Builder class for creating consistent chip styles.
///
/// This class constructs [ChipStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for chip styling.
///
/// Example:
/// ```dart
/// final style = ChipStyleBuilder.build(
///   context: context,
///   variant: ChipVariant.filled,
///   size: ChipSize.medium,
/// );
///
/// final colors = style.resolve(
///   selected: true,
///   disabled: false,
/// );
/// ```
abstract final class ChipStyleBuilder {
  static const double _disabledOpacity = 0.38;

  /// Builds a [ChipStyle] configuration with the given parameters.
  static ChipStyle build({
    required BuildContext context,
    required ChipVariant variant,
    required ChipSize size,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color backgroundColor;
    Color foregroundColor;
    Color selectedBackgroundColor;
    Color selectedForegroundColor;
    Color disabledBackgroundColor;
    Color disabledForegroundColor;
    BorderSide? border;
    EdgeInsetsGeometry padding;
    TextStyle textStyle;
    double borderRadius;
    double iconSize;
    double deleteIconSize;

    switch (variant) {
      case ChipVariant.filled:
        backgroundColor = colorScheme.surfaceVariant;
        foregroundColor = colorScheme.onSurfaceVariant;
        selectedBackgroundColor = colorScheme.primary;
        selectedForegroundColor = colorScheme.onPrimary;
        disabledBackgroundColor = colorScheme.surfaceVariant;
        disabledForegroundColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        border = null;
        break;
      case ChipVariant.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurfaceVariant;
        selectedBackgroundColor = colorScheme.primary;
        selectedForegroundColor = colorScheme.onPrimary;
        disabledBackgroundColor = Colors.transparent;
        disabledForegroundColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        border = BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        );
        break;
      case ChipVariant.tonal:
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        selectedBackgroundColor = colorScheme.primary;
        selectedForegroundColor = colorScheme.onPrimary;
        disabledBackgroundColor = colorScheme.surfaceVariant;
        disabledForegroundColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        border = null;
        break;
    }

    switch (size) {
      case ChipSize.small:
        padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2);
        textStyle = textTheme.labelSmall?.copyWith(
          color: foregroundColor,
        ) ?? const TextStyle(fontSize: 10);
        borderRadius = 12;
        iconSize = 14;
        deleteIconSize = 14;
        break;
      case ChipSize.medium:
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
        textStyle = textTheme.labelMedium?.copyWith(
          color: foregroundColor,
        ) ?? const TextStyle(fontSize: 12);
        borderRadius = 16;
        iconSize = 18;
        deleteIconSize = 16;
        break;
      case ChipSize.large:
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 6);
        textStyle = textTheme.labelLarge?.copyWith(
          color: foregroundColor,
        ) ?? const TextStyle(fontSize: 14);
        borderRadius = 20;
        iconSize = 22;
        deleteIconSize = 20;
        break;
    }

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: border ?? BorderSide.none,
    );

    return ChipStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      selectedForegroundColor: selectedForegroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      padding: padding,
      textStyle: textStyle,
      shape: shape,
      border: border,
      iconSize: iconSize,
      deleteIconSize: deleteIconSize,
    );
  }
}

/// Style configuration for chips.
///
/// Contains all visual properties needed to style a chip consistently.
class ChipStyle {
  /// The background color of the chip.
  final Color backgroundColor;

  /// The foreground color (text/icon) of the chip.
  final Color foregroundColor;

  /// The background color when selected.
  final Color selectedBackgroundColor;

  /// The foreground color when selected.
  final Color selectedForegroundColor;

  /// The background color when disabled.
  final Color disabledBackgroundColor;

  /// The foreground color when disabled.
  final Color disabledForegroundColor;

  /// The padding inside the chip.
  final EdgeInsetsGeometry padding;

  /// The text style of the chip label.
  final TextStyle textStyle;

  /// The shape (including border radius and border) of the chip.
  final ShapeBorder shape;

  /// The border of the chip, if any.
  final BorderSide? border;

  /// The size of icons in the chip.
  final double iconSize;

  /// The size of delete icons in the chip.
  final double deleteIconSize;

  /// Creates a new [ChipStyle].
  const ChipStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.selectedBackgroundColor,
    required this.selectedForegroundColor,
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.padding,
    required this.textStyle,
    required this.shape,
    this.border,
    required this.iconSize,
    required this.deleteIconSize,
  });

  /// Resolves the appropriate colors based on the chip's state.
  ///
  /// Parameters:
  ///   - [selected]: Whether the chip is selected.
  ///   - [disabled]: Whether the chip is disabled.
  ///
  /// Returns:
  ///   A [ChipColors] object containing the resolved background and foreground colors.
  ChipColors resolve({
    required bool selected,
    required bool disabled,
  }) {
    if (disabled) {
      return ChipColors(
        background: disabledBackgroundColor,
        foreground: disabledForegroundColor,
      );
    }

    if (selected) {
      return ChipColors(
        background: selectedBackgroundColor,
        foreground: selectedForegroundColor,
      );
    }

    return ChipColors(
      background: backgroundColor,
      foreground: foregroundColor,
    );
  }
}

/// Resolved colors for a chip based on its state.
class ChipColors {
  /// The background color of the chip.
  final Color background;

  /// The foreground color (text/icon) of the chip.
  final Color foreground;

  /// Creates a new [ChipColors].
  const ChipColors({
    required this.background,
    required this.foreground,
  });
}
