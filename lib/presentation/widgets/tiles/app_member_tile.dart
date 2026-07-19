// lib/presentation/widgets/tiles/app_member_tile.dart

import 'package:flutter/material.dart';

import 'app_tile.dart';
import 'enums/tile_variant.dart';
import 'enums/tile_size.dart';
import 'enums/tile_density.dart';
import 'helpers/tile_style_builder.dart';

/// A member tile for displaying family members.
///
/// This widget provides a standardized member tile that accepts
/// pre-built widgets for all dynamic content. All formatting and business
/// logic should be done before passing data to this widget.
///
/// Example:
/// ```dart
/// AppMemberTile(
///   name: 'John Doe',
///   role: 'Father',
///   email: 'john@example.com',
///   status: Container(
///     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
///     decoration: BoxDecoration(
///       color: Colors.green.withOpacity(0.15),
///       borderRadius: BorderRadius.circular(10),
///     ),
///     child: Text('Active', style: TextStyle(color: Colors.green)),
///   ),
///   avatar: CircleAvatar(child: Text('JD')),
/// )
/// ```
class AppMemberTile extends StatelessWidget {
  /// The member's avatar (image or icon).
  final Widget? avatar;

  /// The member's name.
  final String? name;

  /// The member's role or relationship.
  final String? role;

  /// The member's email or contact.
  final String? email;

  /// The status widget.
  final Widget? status;

  /// Custom trailing widget.
  final Widget? trailing;

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

  /// Creates a new [AppMemberTile].
  const AppMemberTile({
    super.key,
    this.avatar,
    this.name,
    this.role,
    this.email,
    this.status,
    this.trailing,
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
    final colorScheme = Theme.of(context).colorScheme;

    final style = TileStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
      density: density,
    );

    final leading = avatar ??
        CircleAvatar(
          radius: style.avatarRadius,
          backgroundColor: colorScheme.surfaceVariant,
          child: Icon(
            Icons.person,
            color: colorScheme.onSurfaceVariant,
            size: style.iconSize * 0.8,
          ),
        );

    final subtitle = <String>[];
    if (role != null && role!.isNotEmpty) {
      subtitle.add(role!);
    }
    if (email != null && email!.isNotEmpty) {
      subtitle.add(email!);
    }
    final subtitleText = subtitle.join(' • ');

    final trailingWidget = trailing ?? status;

    return AppTile(
      title: name,
      subtitle: subtitleText.isNotEmpty ? subtitleText : null,
      leading: leading,
      trailing: trailingWidget,
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
