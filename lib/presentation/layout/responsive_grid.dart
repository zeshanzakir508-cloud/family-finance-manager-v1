// lib/presentation/layout/responsive_grid.dart

import 'package:flutter/material.dart';

import 'app_layout.dart';
import 'layout_helpers.dart';

/// A responsive grid layout that adapts column count based on screen size.
///
/// This widget provides a flexible grid system that automatically adjusts
/// the number of columns based on the available screen width.
///
/// Example:
/// ```dart
/// ResponsiveGrid(
///   mobileColumns: 1,
///   tabletColumns: 2,
///   desktopColumns: 3,
///   children: [
///     for (var item in items)
///       Card(child: Text(item.title)),
///   ],
/// )
/// ```
class ResponsiveGrid extends StatelessWidget {
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

  /// Creates a new [ResponsiveGrid].
  const ResponsiveGrid({
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
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: GridView.count(
        crossAxisCount: LayoutHelpers.getGridColumnCount(
          context,
          mobileColumns: mobileColumns,
          tabletColumns: tabletColumns,
          desktopColumns: desktopColumns,
        ),
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: childAspectRatio,
        children: children,
      ),
    );
  }
}
