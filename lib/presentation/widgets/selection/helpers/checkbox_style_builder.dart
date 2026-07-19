// lib/presentation/widgets/selection/helpers/checkbox_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/selection_variant.dart';
import '../enums/selection_size.dart';
import '../enums/selection_state.dart';

/// Builder class for creating consistent checkbox styles.
///
/// This class constructs [CheckboxStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for checkbox styling.
///
/// Example:
/// ```dart
/// final style = CheckboxStyleBuilder.build(
///   context: context,
///   variant: SelectionVariant.primary,
///   size: SelectionSize.medium,
///   state: SelectionState.selected,
/// );
/// ```
abstract final class CheckboxStyleBuilder {
  /// Builds a [CheckboxStyle] configuration with the given parameters.
  static CheckboxStyle build({
    required BuildContext context,
    required SelectionVariant variant,
    required SelectionSize size,
    required SelectionState state,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color fillColor;
    Color borderColor;
    Color checkColor;

    switch (state) {
      case SelectionState.selected:
        fillColor = _getActiveColor(colorScheme, variant);
        borderColor = _getActiveColor(colorScheme, variant);
        checkColor = colorScheme.onPrimary;
        break;

      case SelectionState.indeterminate:
        fillColor = _getActiveColor(colorScheme, variant);
        borderColor = _getActiveColor(colorScheme, variant);
        checkColor = colorScheme.onPrimary;
        break;

      case SelectionState.disabled:
        fillColor = colorScheme.surfaceVariant;
        borderColor = colorScheme.onSurfaceVariant.withOpacity(0.38);
        checkColor = colorScheme.onSurfaceVariant.withOpacity(0.38);
        break;

      case SelectionState.unselected:
      default:
        fillColor = Colors.transparent;
        borderColor = colorScheme.onSurfaceVariant;
        checkColor = Colors.transparent;
        break;
    }

    final sizeValue = _getSizeValue(size);

    return CheckboxStyle(
      fillColor: fillColor,
      borderColor: borderColor,
      checkColor: checkColor,
      size: sizeValue,
      borderRadius: BorderRadius.circular(4),
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

/// Style configuration for checkboxes.
@immutable
class CheckboxStyle {
  /// The fill color of the checkbox.
  final Color fillColor;

  /// The border color of the checkbox.
  final Color borderColor;

  /// The color of the check icon.
  final Color checkColor;

  /// The size of the checkbox.
  final double size;

  /// The border radius of the checkbox.
  final BorderRadius borderRadius;

  /// Creates a new [CheckboxStyle].
  const CheckboxStyle({
    required this.fillColor,
    required this.borderColor,
    required this.checkColor,
    required this.size,
    required this.borderRadius,
  });
}
