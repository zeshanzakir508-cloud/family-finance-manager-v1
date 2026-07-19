// lib/presentation/widgets/navigation/bottom_navigation.dart

import 'package:flutter/material.dart';

import '../app_bars/app_bottom_app_bar.dart';
import '../app_bars/enums/app_bar_variant.dart';
import '../app_bars/enums/app_bar_size.dart';

/// A bottom navigation bar with consistent styling.
///
/// This widget provides a standardized bottom navigation bar that follows
/// the application's design system. It can be used with a FloatingActionButton
/// and supports notch margin.
///
/// Example:
/// ```dart
/// BottomNavigation(
///   currentIndex: 0,
///   onTap: (index) => setState(() => _selectedIndex = index),
///   items: const [
///     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
///     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
///   ],
///   fab: FloatingActionButton(
///     onPressed: () => showAddDialog(),
///     child: Icon(Icons.add),
///   ),
/// )
/// ```
class BottomNavigation extends StatelessWidget {
  /// The current selected index.
  final int currentIndex;

  /// Callback when an item is tapped.
  final ValueChanged<int>? onTap;

  /// The navigation items to display.
  final List<BottomNavigationBarItem> items;

  /// The visual variant of the bottom navigation.
  final AppBarVariant variant;

  /// The size of the bottom navigation.
  final AppBarSize size;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Custom elevation override.
  final double? elevation;

  /// Custom shape override.
  final ShapeBorder? shape;

  /// The floating action button to display with a notch.
  final Widget? fab;

  /// Whether the bottom navigation has a notch for the FAB.
  final bool notchMargin;

  /// Creates a new [BottomNavigation].
  const BottomNavigation({
    super.key,
    required this.currentIndex,
    this.onTap,
    required this.items,
    this.variant = AppBarVariant.surface,
    this.size = AppBarSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.shape,
    this.fab,
    this.notchMargin = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveShape = shape ?? const CircularNotchedRectangle();

    // If FAB is provided, use BottomAppBar with notch
    if (fab != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(),
          ),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              AppBottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: items.map((item) {
                    final index = items.indexOf(item);
                    final isSelected = index == currentIndex;
                    return _buildNavItem(
                      context,
                      item: item,
                      index: index,
                      isSelected: isSelected,
                    );
                  }).toList(),
                ),
                notchMargin: notchMargin,
                variant: variant,
                size: size,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                elevation: elevation,
                shape: effectiveShape,
              ),
              Positioned(
                top: -28,
                child: fab!,
              ),
            ],
          ),
        ],
      );
    }

    // Without FAB, use standard BottomNavigationBar
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      selectedItemColor: foregroundColor ?? Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
      elevation: elevation ?? 2,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
      unselectedLabelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w400,
          ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required BottomNavigationBarItem item,
    required int index,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final fgColor = foregroundColor ?? colorScheme.primary;

    final color = isSelected ? fgColor : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: () => onTap?.call(index),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(
                color: color,
                size: 24,
              ),
              child: isSelected
                  ? (item.activeIcon ?? item.icon)
                  : item.icon,
            ),
            if (item.label != null) ...[
              const SizedBox(height: 2),
              Text(
                item.label!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
