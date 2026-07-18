// lib/domain/value_objects/chart_preferences.dart

import 'package:equatable/equatable.dart';

import '../enums/chart_type.dart';

/// Value object representing chart display preferences.
class ChartPreferences extends Equatable {
  /// Whether to show charts on the dashboard.
  final bool showCharts;

  /// Chart type preference.
  final ChartType chartType;

  /// Whether to show legend on charts.
  final bool showLegend;

  /// Whether to show data labels on charts.
  final bool showDataLabels;

  /// Whether to animate chart transitions.
  final bool animateCharts;

  const ChartPreferences({
    this.showCharts = true,
    this.chartType = ChartType.bar,
    this.showLegend = true,
    this.showDataLabels = false,
    this.animateCharts = true,
  });

  /// Creates a copy of these chart preferences with the given fields replaced.
  ChartPreferences copyWith({
    bool? showCharts,
    ChartType? chartType,
    bool? showLegend,
    bool? showDataLabels,
    bool? animateCharts,
  }) {
    return ChartPreferences(
      showCharts: showCharts ?? this.showCharts,
      chartType: chartType ?? this.chartType,
      showLegend: showLegend ?? this.showLegend,
      showDataLabels: showDataLabels ?? this.showDataLabels,
      animateCharts: animateCharts ?? this.animateCharts,
    );
  }

  /// Returns whether charts are shown.
  bool get areChartsShown => showCharts;

  /// Returns whether legend is shown.
  bool get isLegendShown => showLegend;

  /// Returns whether data labels are shown.
  bool get areDataLabelsShown => showDataLabels;

  /// Returns whether animations are enabled.
  bool get areAnimationsEnabled => animateCharts;

  @override
  List<Object?> get props => [
        showCharts,
        chartType,
        showLegend,
        showDataLabels,
        animateCharts,
      ];
}
