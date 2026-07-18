// lib/core/enums/chart_type.dart

/// Enum representing chart type preferences.
enum ChartType {
  /// Bar chart.
  bar,

  /// Line chart.
  line,

  /// Pie chart.
  pie,

  /// Donut chart.
  donut,

  /// Area chart.
  area,
}

/// Extension methods for [ChartType].
extension ChartTypeExtension on ChartType {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [ChartType] from a stored string value.
  static ChartType fromValue(String value) {
    return ChartType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ChartType.bar,
    );
  }

  /// Returns whether this is a categorical chart (bar, pie, donut).
  bool get isCategorical {
    return this == ChartType.bar ||
        this == ChartType.pie ||
        this == ChartType.donut;
  }

  /// Returns whether this is a trend chart (line, area).
  bool get isTrend {
    return this == ChartType.line ||
        this == ChartType.area;
  }

  /// Returns whether this is a circular chart (pie, donut).
  bool get isCircular {
    return this == ChartType.pie ||
        this == ChartType.donut;
  }
}
