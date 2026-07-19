// lib/presentation/widgets/tiles/helpers/tile_style_builder.dart

import 'package:flutter/material.dart';

import '../enums/tile_variant.dart';
import '../enums/tile_size.dart';
import '../enums/tile_density.dart';

/// Builder class for creating consistent tile styles.
///
/// This class constructs [TileStyle] configurations based on the provided
/// parameters, providing a centralized source of truth for tile styling.
///
/// Example:
/// ```dart
/// final style = TileStyleBuilder.build(
///   context: context,
///   variant: TileVariant.filled,
///   size: TileSize.medium,
///   density: TileDensity.comfortable,
/// );
/// ```
abstract final class TileStyleBuilder {
  static const double _disabledOpacity = 0.38;

  /// Builds a [TileStyle] configuration with the given parameters.
  static TileStyle build({
    required BuildContext context,
    required TileVariant variant,
    required TileSize size,
    required TileDensity density,
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
    TextStyle titleStyle;
    TextStyle subtitleStyle;
    double iconSize;
    double avatarRadius;
    double minHeight;
    double contentSpacing;
    double borderRadius;

    switch (variant) {
      case TileVariant.filled:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        selectedBackgroundColor = colorScheme.primary;
        selectedForegroundColor = colorScheme.onPrimary;
        disabledBackgroundColor = colorScheme.surfaceVariant;
        disabledForegroundColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        border = null;
        break;
      case TileVariant.outlined:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        selectedBackgroundColor = colorScheme.primary;
        selectedForegroundColor = colorScheme.onPrimary;
        disabledBackgroundColor = colorScheme.surfaceVariant;
        disabledForegroundColor = colorScheme.onSurfaceVariant.withOpacity(
          _disabledOpacity,
        );
        border = BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        );
        break;
      case TileVariant.tonal:
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

    // Base padding values by size
    double paddingHorizontal;
    double paddingVertical;

    switch (size) {
      case TileSize.compact:
        minHeight = 48;
        paddingHorizontal = 12;
        paddingVertical = 8;
        contentSpacing = 8;
        iconSize = 20;
        avatarRadius = 16;
        titleStyle = textTheme.labelMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w500,
        ) ?? const TextStyle(fontSize: 12);
        subtitleStyle = textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ) ?? const TextStyle(fontSize: 10);
        borderRadius = 8;
        break;
      case TileSize.medium:
        minHeight = 56;
        paddingHorizontal = 16;
        paddingVertical = 10;
        contentSpacing = 12;
        iconSize = 24;
        avatarRadius = 20;
        titleStyle = textTheme.titleMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w500,
        ) ?? const TextStyle(fontSize: 14);
        subtitleStyle = textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ) ?? const TextStyle(fontSize: 12);
        borderRadius = 12;
        break;
      case TileSize.large:
        minHeight = 72;
        paddingHorizontal = 20;
        paddingVertical = 14;
        contentSpacing = 16;
        iconSize = 32;
        avatarRadius = 24;
        titleStyle = textTheme.titleLarge?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w500,
        ) ?? const TextStyle(fontSize: 16);
        subtitleStyle = textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ) ?? const TextStyle(fontSize: 14);
        borderRadius = 16;
        break;
    }

    // Adjust spacing based on density
    if (density == TileDensity.compact) {
      contentSpacing = contentSpacing * 0.6;
      paddingHorizontal = paddingHorizontal * 0.5;
      paddingVertical = paddingVertical * 0.5;
    }

    padding = EdgeInsets.symmetric(
      horizontal: paddingHorizontal,
      vertical: paddingVertical,
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: border ?? BorderSide.none,
    );

    return TileStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      selectedForegroundColor: selectedForegroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      padding: padding,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      iconSize: iconSize,
      avatarRadius: avatarRadius,
      minHeight: minHeight,
      contentSpacing: contentSpacing,
      shape: shape,
      border: border,
    );
  }
}

/// Style configuration for tiles.
///
/// Contains all visual properties needed to style a tile consistently.
class TileStyle {
  /// The background color of the tile.
  final Color backgroundColor;

  /// The foreground color (text/icon) of the tile.
  final Color foregroundColor;

  /// The background color when selected.
  final Color selectedBackgroundColor;

  /// The foreground color when selected.
  final Color selectedForegroundColor;

  /// The background color when disabled.
  final Color disabledBackgroundColor;

  /// The foreground color when disabled.
  final Color disabledForegroundColor;

  /// The padding inside the tile.
  final EdgeInsetsGeometry padding;

  /// The text style of the title.
  final TextStyle titleStyle;

  /// The text style of the subtitle.
  final TextStyle subtitleStyle;

  /// The size of icons in the tile.
  final double iconSize;

  /// The radius of avatars in the tile.
  final double avatarRadius;

  /// The minimum height of the tile.
  final double minHeight;

  /// The spacing between content elements.
  final double contentSpacing;

  /// The shape (including border radius and border) of the tile.
  final ShapeBorder shape;

  /// The border of the tile, if any.
  final BorderSide? border;

  /// Creates a new [TileStyle].
  const TileStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.selectedBackgroundColor,
    required this.selectedForegroundColor,
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.padding,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.iconSize,
    required this.avatarRadius,
    required this.minHeight,
    required this.contentSpacing,
    required this.shape,
    this.border,
  });

  /// Resolves the appropriate colors based on the tile's state.
  ///
  /// Parameters:
  ///   - [selected]: Whether the tile is selected.
  ///   - [disabled]: Whether the tile is disabled.
  ///
  /// Returns:
  ///   A [TileColors] object containing the resolved background and foreground colors.
  TileColors resolve({
    required bool selected,
    required bool disabled,
  }) {
    if (disabled) {
      return TileColors(
        background: disabledBackgroundColor,
        foreground: disabledForegroundColor,
      );
    }

    if (selected) {
      return TileColors(
        background: selectedBackgroundColor,
        foreground: selectedForegroundColor,
      );
    }

    return TileColors(
      background: backgroundColor,
      foreground: foregroundColor,
    );
  }
}

/// Resolved colors for a tile based on its state.
class TileColors {
  /// The background color of the tile.
  final Color background;

  /// The foreground color (text/icon) of the tile.
  final Color foreground;

  /// Creates a new [TileColors].
  const TileColors({
    required this.background,
    required this.foreground,
  });
}
