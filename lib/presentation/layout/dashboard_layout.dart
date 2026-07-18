// lib/presentation/layout/dashboard_layout.dart

/// Enum representing dashboard layout options.
enum DashboardLayout {
  /// Default layout with all widgets.
  defaultLayout,

  /// Compact layout with smaller widgets.
  compact,

  /// Analytics-focused layout with charts.
  analytics,

  /// Minimal layout with only essential widgets.
  minimal,
}

/// Extension methods for [DashboardLayout].
extension DashboardLayoutExtension on DashboardLayout {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [DashboardLayout] from a stored string value.
  static DashboardLayout fromValue(String value) {
    return DashboardLayout.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DashboardLayout.defaultLayout,
    );
  }

  /// Returns whether this is a compact layout.
  bool get isCompact => this == DashboardLayout.compact;

  /// Returns whether this is an analytics layout.
  bool get isAnalytics => this == DashboardLayout.analytics;

  /// Returns whether this is a minimal layout.
  bool get isMinimal => this == DashboardLayout.minimal;

  /// Returns whether this is the default layout.
  bool get isDefault => this == DashboardLayout.defaultLayout;
}
