// lib/presentation/widgets/badges/helpers/badge_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/badge_variant.dart';
import '../enums/badge_size.dart';
import '../enums/badge_shape.dart';

/// Builder class for creating consistent badge styles.
///
/// This class constructs [BadgeStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for badge styling.
///
/// Example:
/// ```dart
/// final style = BadgeStyleBuilder.build(
///   context: context,
///   variant: BadgeVariant.primary,
///   size: BadgeSize.medium,
///   shape: BadgeShape.circular,
/// );
///
/// final colors = style.resolve(
///   selected: true,
///   disabled: false,
/// );
/// ```
abstract final class BadgeStyleBuilder {
  static const double _disabledOpacity = 0.38;

  /// Builds a [BadgeStyle] configuration with the given parameters.
  static BadgeStyle build({
    required BuildContext context,
    required BadgeVariant variant,
    required BadgeSize size,
    required BadgeShape shape,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Color backgroundColor;
    Color foregroundColor;
    Color selectedBackgroundColor;
    Color selectedForegroundColor;
    Color disabledBackgroundColor;
    Color disabledForegroundColor;
    BorderSide? border;
    double borderRadius;
    double sizeValue;
    double iconSize;
    EdgeInsets padding;
    TextStyle textStyle;

    // -------------------------------------------------------------------------
    // Variant-based styling
    // -------------------------------------------------------------------------
    switch (variant) {
      case BadgeVariant.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        selectedBackgroundColor = colorScheme.primaryContainer;
        selectedForegroundColor = colorScheme.onPrimaryContainer;
        disabledBackgroundColor = colorScheme.primary.withOpacity(
          _disabledOpacity,
        );
        disabledForegroundColor = colorScheme.onPrimary.withOpacity(
          _disabledOpacity,
        );
        border = null;
        break;

      case BadgeVariant.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;
        selectedBackgroundColor = colorScheme.secondaryContainer;
        selectedForegroundColor = colorScheme.onSecondaryContainer;
        disabledBackgroundColor = colorScheme.secondary.withOpacity(
          _disabledOpacity,
        );
        disabledForegroundColor = colorScheme.onSecondary.withOpacity(
          _disabledOpacity,
        );
        border = null;
        break;

      case BadgeVariant.success:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        selectedBackgroundColor = colorScheme.primaryContainer;
        selectedForegroundColor = colorScheme.onPrimaryContainer;
        disabledBackgroundColor = colorScheme.primary.withOpacity(
          _disabledOpacity,
        );
        disabledForegroundColor = colorScheme.onPrimary.withOpacity(
          _disabledOpacity,
        );
        border = null;
        break;

      case BadgeVariant.warning:
        backgroundColor = colorScheme.tertiary;
        foregroundColor = colorScheme.onTertiary;
        selectedBackgroundColor = colorScheme.tertiaryContainer;
        selectedForegroundColor = colorScheme.onTertiaryContainer;
        disabledBackgroundColor = colorScheme.tertiary.withOpacity(
          _disabledOpacity,
        );
        disabledForegroundColor = colorScheme.onTertiary.withOpacity(
          _disabledOpacity,
        );
        border = null;
        break;

      case BadgeVariant.error:
        backgroundColor = colorScheme.error;
        foregroundColor = colorScheme.onError;
        selectedBackgroundColor = colorScheme.errorContainer;
        selectedForegroundColor = colorScheme.onErrorContainer;
        disabledBackgroundColor = colorScheme.error.withOpacity(
          _disabledOpacity,
        );
        disabledForegroundColor = colorScheme.onError.withOpacity(
          _disabledOpacity,
        );
        border = null;
        break;

      case BadgeVariant.info:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        selectedBackgroundColor = colorScheme.primaryContainer;
        selectedForegroundColor = colorScheme.onPrimaryContainer;
        disabledBackgroundColor = colorScheme.primary.withOpacity(
          _disabledOpacity,
        );
        disabledForegroundColor = colorScheme.onPrimary.withOpacity(
          _disabledOpacity,
        );
        border = null;
        break;

      case BadgeVariant.neutral:
        backgroundColor = colorScheme.surfaceVariant;
        foregroundColor = colorScheme.onSurfaceVariant;
        selectedBackgroundColor = colorScheme.surfaceContainerHighest;
        selectedForegroundColor = colorScheme.onSurface;
        disabledBackgroundColor = colorScheme.surfaceVariant.withOpacity(
          _disabledOpacity,
        );
        disabledForegroundColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        border = BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        );
        break;
    }

    // -------------------------------------------------------------------------
    // Size-based styling
    // -------------------------------------------------------------------------
    switch (size) {
      case BadgeSize.extraSmall:
        sizeValue = 16;
        iconSize = 10;
        padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2);
        textStyle = textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w600,
        );
        break;

      case BadgeSize.small:
        sizeValue = 20;
        iconSize = 12;
        padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 3);
        textStyle = textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
        );
        break;

      case BadgeSize.medium:
        sizeValue = 24;
        iconSize = 14;
        padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
        textStyle = textTheme.labelMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        );
        break;

      case BadgeSize.large:
        sizeValue = 28;
        iconSize = 16;
        padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
        textStyle = textTheme.labelMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        );
        break;

      case BadgeSize.extraLarge:
        sizeValue = 32;
        iconSize = 18;
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
        textStyle = textTheme.labelLarge?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
        break;
    }

    // -------------------------------------------------------------------------
    // Shape-based styling
    // -------------------------------------------------------------------------
    switch (shape) {
      case BadgeShape.circular:
        borderRadius = sizeValue / 2;
        break;
      case BadgeShape.rounded:
        borderRadius = 4;
        break;
      case BadgeShape.pill:
        borderRadius = sizeValue;
        break;
    }

    final effectiveBorderRadius = shape == BadgeShape.circular
        ? BorderRadius.circular(sizeValue / 2)
        : shape == BadgeShape.pill
            ? BorderRadius.circular(sizeValue)
            : BorderRadius.circular(4);

    final shapeBorder = RoundedRectangleBorder(
      borderRadius: effectiveBorderRadius,
      side: border ?? BorderSide.none,
    );

    return BadgeStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      selectedForegroundColor: selectedForegroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      size: sizeValue,
      iconSize: iconSize,
      padding: padding,
      textStyle: textStyle,
      shape: shapeBorder,
      border: border,
    );
  }
}

/// Style configuration for badges.
///
/// Contains all visual properties needed to style a badge consistently.
@immutable
class BadgeStyle {
  /// The background color of the badge.
  final Color backgroundColor;

  /// The foreground color (text/icon) of the badge.
  final Color foregroundColor;

  /// The background color when selected.
  final Color selectedBackgroundColor;

  /// The foreground color when selected.
  final Color selectedForegroundColor;

  /// The background color when disabled.
  final Color disabledBackgroundColor;

  /// The foreground color when disabled.
  final Color disabledForegroundColor;

  /// The size of the badge.
  final double size;

  /// The size of icons in the badge.
  final double iconSize;

  /// The padding inside the badge.
  final EdgeInsets padding;

  /// The text style of the badge label.
  final TextStyle textStyle;

  /// The shape of the badge.
  final ShapeBorder shape;

  /// The border of the badge, if any.
  final BorderSide? border;

  /// Creates a new [BadgeStyle].
  const BadgeStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.selectedBackgroundColor,
    required this.selectedForegroundColor,
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.size,
    required this.iconSize,
    required this.padding,
    required this.textStyle,
    required this.shape,
    this.border,
  });

  /// Resolves the appropriate colors based on the badge's state.
  ///
  /// Parameters:
  ///   - [selected]: Whether the badge is selected.
  ///   - [disabled]: Whether the badge is disabled.
  ///
  /// Returns:
  ///   A [BadgeColors] object containing the resolved background and
  ///   foreground colors.
  BadgeColors resolve({
    required bool selected,
    required bool disabled,
  }) {
    if (disabled) {
      return BadgeColors(
        background: disabledBackgroundColor,
        foreground: disabledForegroundColor,
      );
    }

    if (selected) {
      return BadgeColors(
        background: selectedBackgroundColor,
        foreground: selectedForegroundColor,
      );
    }

    return BadgeColors(
      background: backgroundColor,
      foreground: foregroundColor,
    );
  }
}

/// Resolved colors for a badge based on its state.
@immutable
class BadgeColors {
  /// The background color of the badge.
  final Color background;

  /// The foreground color (text/icon) of the badge.
  final Color foreground;

  /// Creates a new [BadgeColors].
  const BadgeColors({
    required this.background,
    required this.foreground,
  });
}
