// lib/presentation/widgets/layout/app_constrained_box.dart

import 'package:flutter/material.dart';

/// A constrained box with consistent max width.
///
/// This widget provides a standardized constrained box that limits
/// content width for better readability on larger screens.
///
/// Example:
/// ```dart
/// AppConstrainedBox(
///   maxWidth: 600,
///   child: MyContent(),
/// )
/// ```
class AppConstrainedBox extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// The maximum width of the content.
  final double maxWidth;

  /// Custom padding override.
  final EdgeInsetsGeometry? padding;

  /// Whether to center the content.
  final bool center;

  /// Creates a new [AppConstrainedBox].
  const AppConstrainedBox({
    super.key,
    required this.child,
    this.maxWidth = 600,
    this.padding,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }

    if (center) {
      content = Center(
        child: content,
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      child: content,
    );
  }
}
