// lib/presentation/widgets/layout/app_safe_area.dart

import 'package:flutter/material.dart';

/// A safe area wrapper with consistent padding.
///
/// This widget provides a standardized safe area that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppSafeArea(
///   child: MyContent(),
/// )
/// ```
class AppSafeArea extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// Whether to apply top padding.
  final bool top;

  /// Whether to apply bottom padding.
  final bool bottom;

  /// Whether to apply left padding.
  final bool left;

  /// Whether to apply right padding.
  final bool right;

  /// Custom minimum padding.
  final EdgeInsets? minimum;

  /// Creates a new [AppSafeArea].
  const AppSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.minimum,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      minimum: minimum ?? const EdgeInsets.all(0),
      child: child,
    );
  }
}
