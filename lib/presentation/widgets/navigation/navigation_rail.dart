// lib/presentation/widgets/navigation/app_navigation_rail.dart

import 'package:flutter/material.dart';

import 'enums/navigation_variant.dart';
import 'enums/navigation_size.dart';
import 'enums/navigation_label_behavior.dart';
import 'helpers/navigation_style_builder.dart';

/// A navigation rail with consistent styling.
///
/// This widget provides a standardized navigation rail that follows
/// the application's design system with support for multiple variants,
/// sizes, and label behaviors.
///
/// Example:
/// ```dart
/// AppNavigationRail(
///   currentIndex: 0,
///   onTap: (index) => setState(() => _selectedIndex = index),
///   destinations: const [
///     NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
///     NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profile')),
///   ],
/// )
/// ```
class AppNavigationRail extends StatelessWidget {
  /// The current selected index.
  final int currentIndex;

  /// Callback when an item is tapped.
  final ValueChanged<int>? onTap;

  /// The navigation destinations to display.
  final List<NavigationRailDestination> destinations;

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

  /// Whether the rail is extended (shows labels).
  final bool extended;

  /// Creates a new [AppNavigationRail].
  const AppNavigationRail({
    super.key,
    required this.currentIndex,
    this.onTap,
    required this.destinations,
    this.variant = NavigationVariant.surface,
    this.size = NavigationSize.medium,
    this.labelBehavior = NavigationLabelBehavior.showSelected,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.disabled = false,
    this.extended = false,
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

    final showLabels = _shouldShowLabel();

    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: disabled ? null : onTap,
      destinations: destinations,
      backgroundColor: bgColor,
      indicatorColor: style.indicatorColor,
      elevation: effectiveElevation,
      extended: extended || showLabels,
      minWidth: size.railWidth,
      minExtendedWidth: size.railWidth + 64,
      labelType: _mapLabelBehavior(),
      useIndicator: true,
      groupAlignment: -1.0,
      leading: const SizedBox.shrink(),
      trailing: const SizedBox.shrink(),
    );
  }

  NavigationRailLabelType _mapLabelBehavior() {
    switch (labelBehavior) {
      case NavigationLabelBehavior.alwaysShow:
        return NavigationRailLabelType.all;
      case NavigationLabelBehavior.showSelected:
        return NavigationRailLabelType.selected;
      case NavigationLabelBehavior.neverShow:
        return NavigationRailLabelType.none;
    }
  }

  bool _shouldShowLabel() {
    return labelBehavior != NavigationLabelBehavior.neverShow;
  }
}
