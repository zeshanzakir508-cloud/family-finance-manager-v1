// lib/presentation/widgets/utility/app_keep_alive.dart

import 'package:flutter/material.dart';

/// A widget that keeps its child alive.
///
/// This widget provides a standardized way to keep widgets alive
/// without boilerplate.
///
/// Example:
/// ```dart
/// AppKeepAlive(
///   child: MyExpensiveWidget(),
/// )
/// ```
class AppKeepAlive extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// Whether to keep the child alive.
  final bool keepAlive;

  /// Creates a new [AppKeepAlive].
  const AppKeepAlive({
    super.key,
    required this.child,
    this.keepAlive = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!keepAlive) return child;

    return AutomaticKeepAlive(
      child: child,
    );
  }
}
