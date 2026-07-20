// lib/presentation/widgets/utility/app_measure_size.dart

import 'package:flutter/material.dart';

import 'internal/size_listener.dart';

/// A widget that measures its size.
///
/// This widget provides a standardized way to measure the size
/// of a child widget.
///
/// Example:
/// ```dart
/// AppMeasureSize(
///   onSizeChanged: (size) => print('Size: $size'),
///   child: MyWidget(),
/// )
/// ```
class AppMeasureSize extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// Callback when the size changes.
  final void Function(Size size) onSizeChanged;

  /// Creates a new [AppMeasureSize].
  const AppMeasureSize({
    super.key,
    required this.child,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizeListener(
      onSizeChanged: onSizeChanged,
      child: child,
    );
  }
}
