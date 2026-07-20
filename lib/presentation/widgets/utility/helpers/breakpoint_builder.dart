// lib/presentation/widgets/utility/helpers/breakpoint_builder.dart

import 'package:flutter/material.dart';

import '../enums/responsive_breakpoint.dart';

/// Helper class for breakpoint-based layout building.
///
/// This class provides methods for building layouts based on
/// specific breakpoints.
///
/// Example:
/// ```dart
/// final widget = BreakpointBuilder.build(
///   context: context,
///   builder: (breakpoint) {
///     return breakpoint == ResponsiveBreakpoint.mobile
///         ? MobileWidget()
///         : DesktopWidget();
///   },
/// );
/// ```
abstract final class BreakpointBuilder {
  /// Builds a widget based on the current breakpoint.
  static Widget build({
    required BuildContext context,
    required Widget Function(ResponsiveBreakpoint) builder,
  }) {
    final breakpoint = ResponsiveBreakpoint.fromWidth(
      MediaQuery.of(context).size.width,
    );
    return builder(breakpoint);
  }

  /// Builds a widget with a builder that receives the breakpoint and size.
  static Widget buildWithSize({
    required BuildContext context,
    required Widget Function(
      ResponsiveBreakpoint breakpoint,
      Size size,
    ) builder,
  }) {
    final size = MediaQuery.of(context).size;
    final breakpoint = ResponsiveBreakpoint.fromWidth(size.width);
    return builder(breakpoint, size);
  }
}
