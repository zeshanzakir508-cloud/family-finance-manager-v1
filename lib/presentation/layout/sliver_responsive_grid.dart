// lib/presentation/layout/sliver_responsive_grid.dart

import 'package:flutter/material.dart';

import 'app_layout.dart';
import 'layout_helpers.dart';

/// A sliver version of [ResponsiveGrid] for use in CustomScrollView.
///
/// Example:
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverResponsiveGrid(
///       mobileColumns: 1,
///       tabletColumns: 2,
///       desktopColumns: 3,
///       children: [...],
///     ),
///   ],
/// )
/// ```
class SliverResponsiveGrid extends StatelessWidget {
  /// The number of columns on mobile devices.
  final int mobileColumns;

  /// The number of columns on tablet devices.
  final int tabletColumns;

  /// The number of columns on desktop devices.
  final int desktopColumns;

  /// The spacing between grid items.
  final double spacing;

  /// The run spacing between grid rows.
  final double runSpacing;

  /// The child aspect ratio.
  final double childAspectRatio;

  /// The children to display in the grid.
  final List<Widget> children;

  /// The padding around the grid.
  final EdgeInsetsGeometry? padding;

  /// Creates a new [SliverResponsiveGrid].
  const SliverResponsiveGrid({
    super.key,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = AppLayout.defaultGridSpacing,
    this.runSpacing = AppLayout.defaultGridRunSpacing,
    this.childAspectRatio = AppLayout.defaultGridChildAspectRatio,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? EdgeInsets.zero,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: LayoutHelpers.getGridColumnCount(
            context,
            mobileColumns: mobileColumns,
            tabletColumns: tabletColumns,
            desktopColumns: desktopColumns,
          ),
          crossAxisSpacing: spacing,
          mainAxisSpacing: runSpacing,
          childAspectRatio: childAspectRatio,
        ),
        delegate: SliverChildListDelegate(children),
      ),
    );
  }
}
