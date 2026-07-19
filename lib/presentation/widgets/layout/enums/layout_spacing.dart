// lib/presentation/widgets/layout/enums/layout_spacing.dart

/// Predefined spacing values for consistent layout.
enum LayoutSpacing {
  /// Extra small spacing (4px).
  xs,

  /// Small spacing (8px).
  sm,

  /// Medium spacing (16px).
  md,

  /// Large spacing (24px).
  lg,

  /// Extra large spacing (32px).
  xl,

  /// Double extra large spacing (48px).
  xxl;

  /// Returns the spacing value in pixels.
  double get value {
    switch (this) {
      case LayoutSpacing.xs:
        return 4;
      case LayoutSpacing.sm:
        return 8;
      case LayoutSpacing.md:
        return 16;
      case LayoutSpacing.lg:
        return 24;
      case LayoutSpacing.xl:
        return 32;
      case LayoutSpacing.xxl:
        return 48;
    }
  }
}
