// lib/presentation/widgets/tiles/app_setting_tile.dart

import 'package:flutter/material.dart';

import 'app_tile.dart';
import 'enums/tile_variant.dart';
import 'enums/tile_size.dart';
import 'enums/tile_density.dart';

/// A setting tile with configurable controls.
///
/// This widget provides a standardized setting tile that supports
/// switches, checkboxes, and custom trailing widgets.
///
/// Example:
/// ```dart
/// AppSettingTile(
///   title: 'Dark Mode',
///   leading: Icon(Icons.dark_mode),
///   control: Switch(
///     value: isDarkMode,
///     onChanged: (value) => toggleDarkMode(value),
///   ),
/// )
/// ```
class AppSettingTile extends StatelessWidget {
  /// The main title text.
  final String? title;

  /// The subtitle text displayed below the title.
  final String? subtitle;

  /// Leading widget (e.g., icon, avatar) displayed before the title.
  final Widget? leading;

  /// The control widget (Switch, Checkbox, etc.) displayed as trailing.
  final Widget? control;

  /// Optional custom trailing widget override.
  final Widget? trailing;

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

  /// Creates a new [AppSettingTile].
  const AppSettingTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.control,
    this.trailing,
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
    final effectiveTrailing = trailing ?? control;

    return AppTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: effectiveTrailing,
      child: child,
      onTap: onTap,
      onLongPress: onLongPress,
      selected: selected,
      isDisabled: isDisabled,
      variant: variant,
      size: size,
      density: density,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: padding,
      margin: margin,
      shape: shape,
      border: border,
    );
  }
}
