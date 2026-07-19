// lib/presentation/widgets/selection/helpers/selection_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/selection_variant.dart';
import '../enums/selection_size.dart';

/// Builder class for creating consistent selection styles.
///
/// This class constructs [SelectionStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for selection styling.
///
/// Example:
/// ```dart
/// final style = SelectionStyleBuilder.build(
///   context: context,
///   variant: SelectionVariant.primary,
///   size: SelectionSize.medium,
/// );
/// ```
abstract final class SelectionStyleBuilder {
  static const double _disabledOpacity = 0.38;

  /// Builds a [SelectionStyle] configuration with the given parameters.
  static SelectionStyle build({
    required BuildContext context,
    required SelectionVariant variant,
    required SelectionSize size,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Color activeColor;
    Color inactiveColor;
    Color disabledColor;
    double sizeValue;
    double iconSize;
    TextStyle labelStyle;

    switch (variant) {
      case SelectionVariant.primary:
        activeColor = colorScheme.primary;
        inactiveColor = colorScheme.surfaceVariant;
        disabledColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        break;

      case SelectionVariant.secondary:
        activeColor = colorScheme.secondary;
        inactiveColor = colorScheme.surfaceVariant;
        disabledColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        break;

      case SelectionVariant.success:
        activeColor = colorScheme.primary;
        inactiveColor = colorScheme.surfaceVariant;
        disabledColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        break;

      case SelectionVariant.warning:
        activeColor = colorScheme.tertiary;
        inactiveColor = colorScheme.surfaceVariant;
        disabledColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        break;

      case SelectionVariant.error:
        activeColor = colorScheme.error;
        inactiveColor = colorScheme.surfaceVariant;
        disabledColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        break;

      case SelectionVariant.neutral:
        activeColor = colorScheme.primary;
        inactiveColor = colorScheme.surfaceVariant;
        disabledColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        break;
    }

    switch (size) {
      case SelectionSize.small:
        sizeValue = 16;
        iconSize = 12;
        labelStyle = textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurface,
        ) ?? const TextStyle(fontSize: 10);
        break;

      case SelectionSize.medium:
        sizeValue = 20;
        iconSize = 16;
        labelStyle = textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ) ?? const TextStyle(fontSize: 12);
        break;

      case SelectionSize.large:
        sizeValue = 24;
        iconSize = 20;
        labelStyle = textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurface,
        ) ?? const TextStyle(fontSize: 14);
        break;

      case SelectionSize.extraLarge:
        sizeValue = 28;
        iconSize = 24;
        labelStyle = textTheme.titleSmall?.copyWith(
          color: colorScheme.onSurface,
        ) ?? const TextStyle(fontSize: 16);
        break;
    }

    return SelectionStyle(
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      disabledColor: disabledColor,
      size: sizeValue,
      iconSize: iconSize,
      labelStyle: labelStyle,
      borderRadius: BorderRadius.circular(4),
    );
  }
}

/// Style configuration for selection widgets.
@immutable
class SelectionStyle {
  /// The color when active/selected.
  final Color activeColor;

  /// The color when inactive/unselected.
  final Color inactiveColor;

  /// The color when disabled.
  final Color disabledColor;

  /// The size of the selection widget.
  final double size;

  /// The size of the icon inside the selection widget.
  final double iconSize;

  /// The text style of the label.
  final TextStyle labelStyle;

  /// The border radius of the selection widget.
  final BorderRadius borderRadius;

  /// Creates a new [SelectionStyle].
  const SelectionStyle({
    required this.activeColor,
    required this.inactiveColor,
    required this.disabledColor,
    required this.size,
    required this.iconSize,
    required this.labelStyle,
    required this.borderRadius,
  });
}
