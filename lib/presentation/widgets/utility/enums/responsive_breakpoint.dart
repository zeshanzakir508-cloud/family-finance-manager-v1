// lib/presentation/widgets/utility/enums/responsive_breakpoint.dart

/// Responsive breakpoints for layout adaptation.
enum ResponsiveBreakpoint {
  /// Mobile breakpoint (under 600px).
  mobile,

  /// Tablet breakpoint (600-1024px).
  tablet,

  /// Desktop breakpoint (1024-1440px).
  desktop,

  /// Large desktop breakpoint (1440px+).
  largeDesktop;

  /// Returns the minimum width for this breakpoint.
  double get minWidth {
    switch (this) {
      case ResponsiveBreakpoint.mobile:
        return 0;
      case ResponsiveBreakpoint.tablet:
        return 600;
      case ResponsiveBreakpoint.desktop:
        return 1024;
      case ResponsiveBreakpoint.largeDesktop:
        return 1440;
    }
  }

  /// Returns the maximum width for this breakpoint.
  double get maxWidth {
    switch (this) {
      case ResponsiveBreakpoint.mobile:
        return 599;
      case ResponsiveBreakpoint.tablet:
        return 1023;
      case ResponsiveBreakpoint.desktop:
        return 1439;
      case ResponsiveBreakpoint.largeDesktop:
        return double.infinity;
    }
  }

  /// Returns the breakpoint from a given width.
  static ResponsiveBreakpoint fromWidth(double width) {
    if (width < 600) return ResponsiveBreakpoint.mobile;
    if (width < 1024) return ResponsiveBreakpoint.tablet;
    if (width < 1440) return ResponsiveBreakpoint.desktop;
    return ResponsiveBreakpoint.largeDesktop;
  }
}
