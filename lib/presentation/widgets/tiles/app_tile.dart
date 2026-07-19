// lib/presentation/widgets/tiles/app_tile.dart

import 'package:flutter/material.dart';

import 'enums/tile_variant.dart';
import 'enums/tile_size.dart';
import 'enums/tile_density.dart';
import 'helpers/tile_style_builder.dart';
import 'internal/tile_content.dart';

/// A customizable base tile widget for the application.
///
/// This widget provides a standardized tile with consistent styling,
/// supporting headers, content, and interaction. All other tiles
/// (navigation, setting, transaction, etc.) should reuse this widget.
///
/// Example:
/// ```dart
/// AppTile(
///   title: 'Total Balance',
///   subtitle: '\$12,450.00',
///   leading: Icon(Icons.wallet),
///   trailing: Icon(Icons.chevron_right),
///   onTap: () => navigateToDetails(),
/// )
/// ```
class AppTile extends StatelessWidget {
  /// The main title text.
  final String? title;

  /// The subtitle text displayed below the title.
  final String? subtitle;

  /// Leading widget (e.g., icon, avatar) displayed before the title.
  final Widget? leading;

  /// Trailing widget (e.g., icon, button) displayed after the title.
  final Widget? trailing;

  /// Footer widget displayed below the main content.
  final Widget? footer;

  /// Optional child widget displayed below the title/subtitle.
  final Widget? child;

  /// Callback when the tile is tapped.
  final VoidCallback? onTap;

  /// Callback when the tile is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether the tile is selected.
  final bool selected;

  /// Whether the tile is disabled.
  final bool isDisabled;

  /// The visual variant of the tile.
  final TileVariant variant;

  /// The size of the tile.
  final TileSize size;

  /// The density of the tile.
  final TileDensity density;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Custom padding override.
  final EdgeInsetsGeometry? padding;

  /// Custom margin override.
  final EdgeInsetsGeometry? margin;

  /// Custom shape override.
  final ShapeBorder? shape;

  /// Custom border override.
  final BorderSide? border;

  /// Creates a new [AppTile].
  const AppTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.footer,
    this.child,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.isDisabled = false,
    this.variant = TileVariant.filled,
    this.size = TileSize.medium,
    this.density = TileDensity.comfortable,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.margin,
    this.shape,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final style = TileStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
      density: density,
    );

    final colors = style.resolve(
      selected: selected,
      disabled: isDisabled,
    );

    final bgColor = backgroundColor ?? colors.background;
    final fgColor = foregroundColor ?? colors.foreground;
    final effectivePadding = padding ?? style.padding;
    final effectiveShape = shape ?? style.shape;
    final effectiveMargin = margin ?? const EdgeInsets.all(0);

    final content = TileContent(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      footer: footer,
      child: child,
      style: style,
      fgColor: fgColor,
    );

    Widget tile = Material(
      color: bgColor,
      shape: effectiveShape,
      elevation: 0,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        onLongPress: isDisabled ? null : onLongPress,
        borderRadius: _getBorderRadius(effectiveShape),
        child: Padding(
          padding: effectivePadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: style.minHeight),
            child: content,
          ),
        ),
      ),
    );

    if (effectiveMargin != EdgeInsets.zero) {
      tile = Padding(
        padding: effectiveMargin,
        child: tile,
      );
    }

    return tile;
  }

  BorderRadiusGeometry? _getBorderRadius(ShapeBorder? shape) {
    if (shape is RoundedRectangleBorder) {
      return shape.borderRadius;
    }
    return null;
  }
}
