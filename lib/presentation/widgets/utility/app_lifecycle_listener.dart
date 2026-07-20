// lib/presentation/widgets/utility/app_lifecycle_listener.dart

import 'package:flutter/material.dart';

import 'enums/lifecycle_state.dart';
import 'internal/lifecycle_listener.dart';

/// A widget that listens to application lifecycle changes.
///
/// This widget provides a standardized way to listen to lifecycle
/// events.
///
/// Example:
/// ```dart
/// AppLifecycleListener(
///   onStateChanged: (state) {
///     if (state == LifecycleState.resumed) {
///       refreshData();
///     }
///   },
///   child: MyWidget(),
/// )
/// ```
class AppLifecycleListener extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// Callback when the lifecycle state changes.
  final void Function(LifecycleState state) onStateChanged;

  /// Creates a new [AppLifecycleListener].
  const AppLifecycleListener({
    super.key,
    required this.child,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LifecycleListener(
      onStateChanged: onStateChanged,
      child: child,
    );
  }
}
