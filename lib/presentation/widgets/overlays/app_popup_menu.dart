// lib/presentation/widgets/overlays/app_popup_menu.dart

import 'package:flutter/material.dart';

import 'enums/overlay_variant.dart';
import 'enums/overlay_position.dart';
import 'enums/overlay_animation.dart';
import 'helpers/overlay_style_builder.dart';

/// A popup menu widget with consistent styling.
///
/// This widget provides a standardized popup menu that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppPopupMenu(
///   items: [
///     PopupMenuItem(label: 'Edit', icon: Icons.edit, onTap: () {}),
///     PopupMenuItem(label: 'Delete', icon: Icons.delete, onTap: () {}),
///   ],
///   child: IconButton(icon: Icon(Icons.more_vert)),
/// )
/// ```
class AppPopupMenu extends StatelessWidget {
  /// The list of menu items.
  final List<PopupMenuItem> items;

  /// The child widget that triggers the menu.
  final Widget child;

  /// The visual variant of the menu.
  final OverlayVariant variant;

  /// The position of the menu relative to the child.
  final OverlayPosition position;

  /// The animation type.
  final OverlayAnimation animation;

  /// The offset of the menu from the child.
  final Offset offset;

  /// Whether the menu is enabled.
  final bool enabled;

  /// Creates a new [AppPopupMenu].
  const AppPopupMenu({
    super.key,
    required this.items,
    required this.child,
    this.variant = OverlayVariant.surface,
    this.position = OverlayPosition.bottom,
    this.animation = OverlayAnimation.scale,
    this.offset = Offset.zero,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => items.map((item) {
        return PopupMenuItem(
          value: item,
          onTap: item.onTap,
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(item.icon, size: 20),
                const SizedBox(width: 12),
              ],
              Text(item.label),
            ],
          ),
        );
      }).toList(),
      child: child,
      position: _mapPosition(),
      offset: offset,
      enabled: enabled,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  PopupMenuPosition _mapPosition() {
    switch (position) {
      case OverlayPosition.top:
        return PopupMenuPosition.over;
      case OverlayPosition.bottom:
        return PopupMenuPosition.under;
      default:
        return PopupMenuPosition.under;
    }
  }
}

/// A popup menu item.
class PopupMenuItem {
  /// The label text.
  final String label;

  /// The optional icon.
  final IconData? icon;

  /// The callback when the item is tapped.
  final VoidCallback? onTap;

  /// Creates a new [PopupMenuItem].
  const PopupMenuItem({
    required this.label,
    this.icon,
    this.onTap,
  });
}
