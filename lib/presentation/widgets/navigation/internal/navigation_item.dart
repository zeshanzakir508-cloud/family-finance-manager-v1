// lib/presentation/widgets/navigation/internal/navigation_item.dart

import 'package:flutter/material.dart';

import '../helpers/navigation_style_builder.dart';

/// Internal widget for rendering a navigation item.
///
/// This widget provides consistent rendering of navigation items with
/// icon, label, and selection states.
class NavigationItem extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// The label text to display.
  final String? label;

  /// Whether the item is selected.
  final bool selected;

  /// Whether the item is disabled.
  final bool disabled;

  /// The navigation style.
  final NavigationStyle style;

  /// The resolved colors for the current state.
  final NavigationColors colors;

  /// The label behavior.
  final NavigationLabelBehavior labelBehavior;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  /// Creates a new [NavigationItem].
  const NavigationItem({
    super.key,
    required this.icon,
    this.label,
    required this.selected,
    required this.disabled,
    required this.style,
    required this.colors,
    required this.labelBehavior,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final showLabel = _shouldShowLabel();
    final isDisabled = disabled || onTap == null;

    final labelStyle = selected
        ? style.selectedLabelStyle
        : style.labelStyle;

    final effectiveColor = isDisabled
        ? colors.foreground.withOpacity(0.38)
        : colors.foreground;

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: effectiveColor,
              size: style.iconSize,
            ),
            if (showLabel) ...[
              SizedBox(height: style.labelSpacing),
              Text(
                label!,
                style: labelStyle.copyWith(
                  color: effectiveColor,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _shouldShowLabel() {
    if (label == null || label!.isEmpty) return false;

    switch (labelBehavior) {
      case NavigationLabelBehavior.alwaysShow:
        return true;
      case NavigationLabelBehavior.showSelected:
        return selected;
      case NavigationLabelBehavior.neverShow:
        return false;
    }
  }
}
