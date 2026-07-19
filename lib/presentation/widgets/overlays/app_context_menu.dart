// lib/presentation/widgets/overlays/app_context_menu.dart

import 'package:flutter/material.dart';

import 'enums/overlay_variant.dart';
import 'enums/overlay_position.dart';
import 'enums/overlay_animation.dart';
import 'helpers/overlay_style_builder.dart';

/// A context menu widget with consistent styling.
///
/// This widget provides a standardized context menu that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppContextMenu(
///   items: [
///     ContextMenuItem(label: 'Copy', icon: Icons.copy, onTap: () {}),
///     ContextMenuItem(label: 'Delete', icon: Icons.delete, onTap: () {}),
///   ],
///   child: Container(
///     child: Text('Long press me'),
///   ),
/// )
/// ```
class AppContextMenu extends StatelessWidget {
  /// The list of menu items.
  final List<ContextMenuItem> items;

  /// The child widget that triggers the menu.
  final Widget child;

  /// The visual variant of the menu.
  final OverlayVariant variant;

  /// The animation type.
  final OverlayAnimation animation;

  /// Creates a new [AppContextMenu].
  const AppContextMenu({
    super.key,
    required this.items,
    required this.child,
    this.variant = OverlayVariant.surface,
    this.animation = OverlayAnimation.scale,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: child,
    );
  }

  void _showContextMenu(BuildContext context) {
    final style = OverlayStyleBuilder.build(
      context: context,
      variant: variant,
    );

    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 100, 100),
      items: items.map((item) {
        return PopupMenuItem(
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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

/// A context menu item.
class ContextMenuItem {
  /// The label text.
  final String label;

  /// The optional icon.
  final IconData? icon;

  /// The callback when the item is tapped.
  final VoidCallback? onTap;

  /// Creates a new [ContextMenuItem].
  const ContextMenuItem({
    required this.label,
    this.icon,
    this.onTap,
  });
}
