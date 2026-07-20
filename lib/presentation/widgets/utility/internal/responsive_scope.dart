// lib/presentation/widgets/utility/internal/responsive_scope.dart

import 'package:flutter/material.dart';

import '../enums/responsive_breakpoint.dart';

/// Internal widget for providing responsive scope.
class ResponsiveScope extends InheritedWidget {
  final ResponsiveBreakpoint breakpoint;
  final Size size;

  const ResponsiveScope({
    super.key,
    required this.breakpoint,
    required this.size,
    required super.child,
  });

  static ResponsiveScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ResponsiveScope>();
    assert(scope != null, 'No ResponsiveScope found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(ResponsiveScope oldWidget) {
    return breakpoint != oldWidget.breakpoint || size != oldWidget.size;
  }
}
