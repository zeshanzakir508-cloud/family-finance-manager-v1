// lib/presentation/widgets/selection/app_selectable_tile.dart

import 'package:flutter/material.dart';

import '../tiles/app_tile.dart';
import '../tiles/enums/tile_variant.dart';
import '../tiles/enums/tile_size.dart';
import '../tiles/enums/tile_density.dart';

/// A selectable tile widget with consistent styling.
///
/// This widget provides a standardized selectable tile that follows
/// the application's design system.
///
/// Example:
/// ```dart
/// AppSelectableTile(
///   title: 'Account 1',
///   subtitle: 'PKR 2,500',
///   leading: Icon(Icons.account_balance),
///   selected: selectedIndex == 0,
///   onTap: () => setState(() => selectedIndex = 0),
/// )
/// ```
class AppSelectableTile extends StatelessWidget {
  /// The main title text.
  final String? title;

  /// The subtitle text.
  final String? subtitle;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// Whether the tile is selected.
  final bool selected;

  /// Callback when the tile is tapped.
  final VoidCallback? onTap;

  /// Whether the tile is disabled.
  final bool isDisabled;

  /// The visual variant of the tile.
  final TileVariant variant;

  /// The size of the tile.
  final TileSize size;

  /// The density of the tile.
  final TileDensity density;

  /// Creates a new [AppSelectableTile].
  const AppSelectableTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.selected,
    this.onTap,
    this.isDisabled = false,
    this.variant = TileVariant.filled,
    this.size = TileSize.medium,
    this.density = TileDensity.comfortable,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveTrailing = trailing ??
        (selected
            ? Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 20,
              )
            : const SizedBox.shrink());

    return AppTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: effectiveTrailing,
      onTap: isDisabled ? null : onTap,
      selected: selected,
      isDisabled: isDisabled,
      variant: variant,
      size: size,
      density: density,
    );
  }
}
