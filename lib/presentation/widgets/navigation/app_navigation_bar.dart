// lib/presentation/widgets/navigation/app_navigation_bar.dart

import 'package:flutter/material.dart';

import 'enums/navigation_variant.dart';
import 'enums/navigation_size.dart';
import 'enums/navigation_label_behavior.dart';
import 'helpers/navigation_style_builder.dart';
import 'internal/navigation_item.dart';

/// A bottom navigation bar with consistent styling.
///
/// This widget provides a standardized bottom navigation bar that follows
/// the application's design system with support for multiple variants,
/// sizes, and label behaviors.
///
/// Example:
/// ```dart
/// AppNavigationBar(
///   currentIndex: 0,
///   onTap: (index) => setState(() => _selectedIndex = index),
///   items: const [
///     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
///     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
///   ],
/// )
/// ```
class AppNavigationBar extends StatelessWidget {
  /// The current selected index.
  final int currentIndex;

  /// Callback when an item is tapped.
  final ValueChanged<int>? onTap;

  /// The navigation items to display.
  final List<BottomNavigationBarItem> items;

  /// The visual variant of the navigation.
  final NavigationVariant variant;

  /// The size of the navigation.
  final NavigationSize size;

  /// The label behavior of the navigation.
  final NavigationLabelBehavior labelBehavior;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Custom elevation override.
  final double? elevation;

  /// Whether the navigation is disabled.
  final bool disabled;

  /// Creates a new [AppNavigationBar].
  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    required this.items,
    this.variant = NavigationVariant.surface,
    this.size = NavigationSize.medium,
    this.labelBehavior = NavigationLabelBehavior.showSelected,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = NavigationStyleBuilder.build(
      context: context,
      variant: variant,
      size: size,
    );

    final colors = style.resolve(
      selected: false,
      disabled: disabled,
    );

    final bgColor = backgroundColor ?? colors.background;
    final fgColor = foregroundColor ?? colors.foreground;
    final effectiveElevation = elevation ?? style.elevation;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: disabled ? null : onTap,
      destinations: items.map((item) => _buildDestination(item, style)).toList(),
      backgroundColor: bgColor,
      indicatorColor: style.indicatorColor,
      elevation: effectiveElevation,
      height: size.barHeight,
      labelBehavior: _mapLabelBehavior(),
    );
  }

  NavigationDestination _buildDestination(
    BottomNavigationBarItem item,
    NavigationStyle style,
  ) {
    final showLabel = _shouldShowLabel();

    return NavigationDestination(
      icon: item.icon,
      selectedIcon: item.activeIcon ?? item.icon,
      label: showLabel ? (item.label ?? '') : '',
      tooltip: item.tooltip,
    );
  }

  NavigationDestinationLabelBehavior _mapLabelBehavior() {
    switch (labelBehavior) {
      case NavigationLabelBehavior.alwaysShow:
        return NavigationDestinationLabelBehavior.alwaysShow;
      case NavigationLabelBehavior.showSelected:
        return NavigationDestinationLabelBehavior.onlyShowSelected;
      case NavigationLabelBehavior.neverShow:
        return NavigationDestinationLabelBehavior.neverShow;
    }
  }

  bool _shouldShowLabel() {
    return labelBehavior != NavigationLabelBehavior.neverShow;
  }
}
