// lib/presentation/widgets/selection/helpers/radio_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/selection_variant.dart';
import '../enums/selection_size.dart';
import '../enums/selection_state.dart';

/// Builder class for creating consistent radio styles.
///
/// This class constructs [RadioStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for radio styling.
///
/// Example:
/// ```dart
/// final style = RadioStyleBuilder.build(
///   context: context,
///   variant: SelectionVariant.primary,
///   size: SelectionSize.medium,
///   state: SelectionState.selected,
/// );
/// ```
abstract final class RadioStyleBuilder {
  /// Builds a [RadioStyle] configuration with the given parameters.
  static RadioStyle build({
    required BuildContext context,
    required SelectionVariant variant,
    required SelectionSize size,
    required SelectionState state,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color activeColor;
    Color inactiveColor;
    Color disabledColor;

    switch (state) {
      case SelectionState.selected:
        activeColor = _getActiveColor(colorScheme, variant);
        inactiveColor = _getActiveColor(colorScheme, variant);
        disabledColor = colorScheme.onSurfaceVariant.withOpacity(0.38);
        break;

      case SelectionState.disabled:
        activeColor = colorScheme.onSurfaceVariant.withOpacity(0.38);
        inactiveColor = colorScheme.onSurfaceVariant.withOpacity(0.38);
        disabledColor = colorScheme.onSurfaceVariant.withOpacity(0.38);
        break;

      case SelectionState.unselected:
      default:
        activeColor = Colors.transparent;
        inactiveColor = colorScheme.onSurfaceVariant;
        disabledColor = colorScheme.onSurfaceVariant.withOpacity(0.38);
        break;
    }

    final sizeValue = _getSizeValue(size);

    return RadioStyle(
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      disabledColor: disabledColor,
      size: sizeValue,
    );
  }

  static Color _getActiveColor(
    ColorScheme colorScheme,
    SelectionVariant variant,
  ) {
    switch (variant) {
      case SelectionVariant.primary:
        return colorScheme.primary;
      case SelectionVariant.secondary:
        return colorScheme.secondary;
      case SelectionVariant.success:
        return colorScheme.primary;
      case SelectionVariant.warning:
        return colorScheme.tertiary;
      case SelectionVariant.error:
        return colorScheme.error;
      case SelectionVariant.neutral:
        return colorScheme.primary;
    }
  }

  static double _getSizeValue(SelectionSize size) {
    switch (size) {
      case SelectionSize.small:
        return 16;
      case SelectionSize.medium:
        return 20;
      case SelectionSize.large:
        return 24;
      case SelectionSize.extraLarge:
        return 28;
    }
  }
}

/// Style configuration for radios.
@immutable
class RadioStyle {
  /// The color when active.
  final Color activeColor;

  /// The color when inactive.
  final Color inactiveColor;

  /// The color when disabled.
  final Color disabledColor;

  /// The size of the radio.
  final double size;

  /// Creates a new [RadioStyle].
  const RadioStyle({
    required this.activeColor,
    required this.inactiveColor,
    required this.disabledColor,
    required this.size,
  });
}
