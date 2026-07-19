// lib/presentation/widgets/navigation/app_tab_bar.dart

import 'package:flutter/material.dart';

import 'enums/navigation_variant.dart';
import 'enums/navigation_size.dart';
import 'helpers/navigation_style_builder.dart';

/// A tab bar with consistent styling.
///
/// This widget provides a standardized tab bar that follows the
/// application's design system with support for multiple variants and sizes.
///
/// Example:
/// ```dart
/// AppTabBar(
///   tabs: const [
///     Tab(text: 'Income'),
///     Tab(text: 'Expenses'),
///     Tab(text: 'All'),
///   ],
///   controller: _tabController,
/// )
/// ```
class AppTabBar extends StatelessWidget {
  /// The list of tabs to display.
  final List<Widget> tabs;

  /// The tab controller.
  final TabController? controller;

  /// Callback when the tab changes.
  final ValueChanged<int>? onTap;

  /// Whether the tab bar is scrollable.
  final bool isScrollable;

  /// The visual variant of the tab bar.
  final NavigationVariant variant;

  /// The size of the tab bar.
  final NavigationSize size;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom foreground color override.
  final Color? foregroundColor;

  /// Custom indicator color override.
  final Color? indicatorColor;

  /// Custom indicator weight override.
  final double? indicatorWeight;

  /// Custom padding override.
  final EdgeInsetsGeometry? padding;

  /// Creates a new [AppTabBar].
  const AppTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.isScrollable = false,
    this.variant = NavigationVariant.surface,
    this.size = NavigationSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.indicatorColor,
    this.indicatorWeight,
    this.padding,
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
      disabled: false,
    );

    final bgColor = backgroundColor ?? colors.background;
    final fgColor = foregroundColor ?? colors.foreground;
    final effectiveIndicatorColor = indicatorColor ?? style.indicatorColor;
    final effectiveIndicatorWeight = indicatorWeight ?? 3.0;

    return TabBar(
      controller: controller,
      onTap: onTap,
      isScrollable: isScrollable,
      tabs: tabs,
      labelColor: fgColor,
      unselectedLabelColor: fgColor.withOpacity(0.6),
      indicatorColor: effectiveIndicatorColor,
      indicatorWeight: effectiveIndicatorWeight,
      labelStyle: style.selectedLabelStyle,
      unselectedLabelStyle: style.labelStyle,
      padding: padding ?? style.labelPadding,
      labelPadding: padding ?? style.labelPadding,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(
        fgColor.withOpacity(0.08),
      ),
    );
  }
}
