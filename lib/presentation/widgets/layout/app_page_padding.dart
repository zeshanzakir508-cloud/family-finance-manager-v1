// lib/presentation/widgets/layout/app_page_padding.dart

import 'package:flutter/material.dart';

import '../layout/app_spacing.dart';

/// A widget that applies consistent page padding.
///
/// This widget provides standardized page padding that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppPagePadding(
///   child: MyContent(),
/// )
/// ```
class AppPagePadding extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// Custom padding override.
  final EdgeInsetsGeometry? padding;

  /// Whether to apply horizontal padding.
  final bool horizontal;

  /// Whether to apply vertical padding.
  final bool vertical;

  /// Creates a new [AppPagePadding].
  const AppPagePadding({
    super.key,
    required this.child,
    this.padding,
    this.horizontal = true,
    this.vertical = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: horizontal ? 16 : 0,
          vertical: vertical ? 16 : 0,
        );

    return Padding(
      padding: effectivePadding,
      child: child,
    );
  }
}
