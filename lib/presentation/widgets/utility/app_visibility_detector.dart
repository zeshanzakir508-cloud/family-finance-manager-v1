// lib/presentation/widgets/utility/app_visibility_detector.dart

import 'package:flutter/material.dart';

/// A widget that detects visibility changes.
///
/// This widget provides a standardized way to detect when a widget
/// becomes visible or hidden.
///
/// Example:
/// ```dart
/// AppVisibilityDetector(
///   onVisibilityChanged: (visible) {
///     if (visible) {
///       loadData();
///     }
///   },
///   child: MyWidget(),
/// )
/// ```
class AppVisibilityDetector extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// Callback when visibility changes.
  final void Function(bool visible) onVisibilityChanged;

  /// The detection mode.
  final VisibilityDetectorMode mode;

  /// Creates a new [AppVisibilityDetector].
  const AppVisibilityDetector({
    super.key,
    required this.child,
    required this.onVisibilityChanged,
    this.mode = VisibilityDetectorMode.visible,
  });

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey('visibility_${child.hashCode}'),
      onVisibilityChanged: (info) {
        final visible = info.visibleFraction > 0.1;
        onVisibilityChanged(visible);
      },
      child: child,
    );
  }
}
