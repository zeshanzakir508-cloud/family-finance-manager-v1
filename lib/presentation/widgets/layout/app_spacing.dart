// lib/presentation/widgets/layout/app_spacing.dart

import 'package:flutter/material.dart';

import 'enums/layout_spacing.dart';

/// A spacing widget with consistent sizing.
///
/// This widget provides standardized spacing that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppSpacing.sm()
/// AppSpacing.lg()
/// AppSpacing.horizontal()
/// ```
class AppSpacing extends StatelessWidget {
  final double width;
  final double height;

  const AppSpacing({
    super.key,
    this.width = 0,
    this.height = 0,
  });

  /// Creates a vertical spacing with the given size.
  factory AppSpacing.vertical(LayoutSpacing size) {
    return AppSpacing(
      height: size.value,
    );
  }

  /// Creates a horizontal spacing with the given size.
  factory AppSpacing.horizontal(LayoutSpacing size) {
    return AppSpacing(
      width: size.value,
    );
  }

  /// Extra small vertical spacing (4px).
  factory AppSpacing.xs() => AppSpacing.vertical(LayoutSpacing.xs);

  /// Small vertical spacing (8px).
  factory AppSpacing.sm() => AppSpacing.vertical(LayoutSpacing.sm);

  /// Medium vertical spacing (16px).
  factory AppSpacing.md() => AppSpacing.vertical(LayoutSpacing.md);

  /// Large vertical spacing (24px).
  factory AppSpacing.lg() => AppSpacing.vertical(LayoutSpacing.lg);

  /// Extra large vertical spacing (32px).
  factory AppSpacing.xl() => AppSpacing.vertical(LayoutSpacing.xl);

  /// Double extra large vertical spacing (48px).
  factory AppSpacing.xxl() => AppSpacing.vertical(LayoutSpacing.xxl);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
