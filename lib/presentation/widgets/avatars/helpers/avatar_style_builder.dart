// lib/presentation/widgets/avatars/helpers/avatar_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/avatar_variant.dart';
import '../enums/avatar_size.dart';
import '../enums/avatar_shape.dart';

/// Builder class for creating consistent avatar styles.
///
/// This class constructs [AvatarStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for avatar styling.
///
/// Example:
/// ```dart
/// final style = AvatarStyleBuilder.build(
///   context: context,
///   variant: AvatarVariant.filled,
///   size: AvatarSize.medium,
///   shape: AvatarShape.circular,
/// );
///
/// final colors = style.resolve(
///   selected: true,
///   disabled: false,
/// );
/// ```
abstract final class AvatarStyleBuilder {
  static const double _disabledOpacity = 0.38;

  /// Builds an [AvatarStyle] configuration with the given parameters.
  static AvatarStyle build({
    required BuildContext context,
    required AvatarVariant variant,
    required AvatarSize size,
    required AvatarShape shape,
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
    double fontSize;
    double borderWidth;

    // -------------------------------------------------------------------------
    // Variant-based styling
    // -------------------------------------------------------------------------
    switch (variant) {
      case AvatarVariant.filled:
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
        borderWidth = 0;
        break;

      case AvatarVariant.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        selectedBackgroundColor = colorScheme.surfaceVariant;
        selectedForegroundColor = colorScheme.primary;
        disabledBackgroundColor = Colors.transparent;
        disabledForegroundColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        border = BorderSide(
          color: colorScheme.outlineVariant,
          width: 2,
        );
        borderWidth = 2;
        break;

      case AvatarVariant.tonal:
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        selectedBackgroundColor = colorScheme.primaryContainer;
        selectedForegroundColor = colorScheme.onPrimaryContainer;
        disabledBackgroundColor = colorScheme.secondaryContainer.withOpacity(
          _disabledOpacity,
        );
        disabledForegroundColor = colorScheme.onSecondaryContainer.withOpacity(
          _disabledOpacity,
        );
        border = null;
        borderWidth = 0;
        break;

      case AvatarVariant.transparent:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        selectedBackgroundColor = Colors.transparent;
        selectedForegroundColor = colorScheme.primary;
        disabledBackgroundColor = Colors.transparent;
        disabledForegroundColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        border = null;
        borderWidth = 0;
        break;
    }

    // -------------------------------------------------------------------------
    // Size-based styling
    // -------------------------------------------------------------------------
    sizeValue = size.value;

    switch (size) {
      case AvatarSize.extraSmall:
        iconSize = 14;
        fontSize = 10;
        break;
      case AvatarSize.small:
        iconSize = 18;
        fontSize = 12;
        break;
      case AvatarSize.medium:
        iconSize = 22;
        fontSize = 16;
        break;
      case AvatarSize.large:
        iconSize = 26;
        fontSize = 20;
        break;
      case AvatarSize.extraLarge:
        iconSize = 30;
        fontSize = 24;
        break;
      case AvatarSize.huge:
        iconSize = 36;
        fontSize = 32;
        break;
    }

    // -------------------------------------------------------------------------
    // Shape-based styling
    // -------------------------------------------------------------------------
    switch (shape) {
      case AvatarShape.circular:
        borderRadius = sizeValue / 2;
        break;
      case AvatarShape.rounded:
        borderRadius = 8;
        break;
      case AvatarShape.square:
        borderRadius = 0;
        break;
    }

    final effectiveBorderRadius = shape == AvatarShape.circular
        ? BorderRadius.circular(sizeValue / 2)
        : shape == AvatarShape.rounded
            ? BorderRadius.circular(8)
            : BorderRadius.zero;

    final shapeBorder = RoundedRectangleBorder(
      borderRadius: effectiveBorderRadius,
      side: border ?? BorderSide.none,
    );

    final textStyle = textTheme.titleMedium?.copyWith(
      color: foregroundColor,
      fontWeight: FontWeight.w600,
    ) ?? const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return AvatarStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      selectedForegroundColor: selectedForegroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      size: sizeValue,
      iconSize: iconSize,
      fontSize: fontSize,
      borderWidth: borderWidth,
      textStyle: textStyle,
      shape: shapeBorder,
      border: border,
    );
  }
}

/// Style configuration for avatars.
///
/// Contains all visual properties needed to style an avatar consistently.
@immutable
class AvatarStyle {
  /// The background color of the avatar.
  final Color backgroundColor;

  /// The foreground color (text/icon) of the avatar.
  final Color foregroundColor;

  /// The background color when selected.
  final Color selectedBackgroundColor;

  /// The foreground color when selected.
  final Color selectedForegroundColor;

  /// The background color when disabled.
  final Color disabledBackgroundColor;

  /// The foreground color when disabled.
  final Color disabledForegroundColor;

  /// The size of the avatar.
  final double size;

  /// The size of icons in the avatar.
  final double iconSize;

  /// The font size for initials.
  final double fontSize;

  /// The border width of the avatar.
  final double borderWidth;

  /// The text style of the avatar label.
  final TextStyle textStyle;

  /// The shape of the avatar.
  final ShapeBorder shape;

  /// The border of the avatar, if any.
  final BorderSide? border;

  /// Creates a new [AvatarStyle].
  const AvatarStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.selectedBackgroundColor,
    required this.selectedForegroundColor,
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.size,
    required this.iconSize,
    required this.fontSize,
    required this.borderWidth,
    required this.textStyle,
    required this.shape,
    this.border,
  });

  /// Resolves the appropriate colors based on the avatar's state.
  ///
  /// Parameters:
  ///   - [selected]: Whether the avatar is selected.
  ///   - [disabled]: Whether the avatar is disabled.
  ///
  /// Returns:
  ///   An [AvatarColors] object containing the resolved background and
  ///   foreground colors.
  AvatarColors resolve({
    required bool selected,
    required bool disabled,
  }) {
    if (disabled) {
      return AvatarColors(
        background: disabledBackgroundColor,
        foreground: disabledForegroundColor,
      );
    }

    if (selected) {
      return AvatarColors(
        background: selectedBackgroundColor,
        foreground: selectedForegroundColor,
      );
    }

    return AvatarColors(
      background: backgroundColor,
      foreground: foregroundColor,
    );
  }
}

/// Resolved colors for an avatar based on its state.
@immutable
class AvatarColors {
  /// The background color of the avatar.
  final Color background;

  /// The foreground color (text/icon) of the avatar.
  final Color foreground;

  /// Creates a new [AvatarColors].
  const AvatarColors({
    required this.background,
    required this.foreground,
  });
}
