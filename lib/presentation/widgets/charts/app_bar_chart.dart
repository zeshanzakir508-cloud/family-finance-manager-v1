// lib/presentation/widgets/charts/app_bar_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'enums/chart_type.dart';
import 'enums/chart_animation.dart';
import 'enums/chart_legend_position.dart';
import 'enums/chart_axis.dart';
import 'enums/chart_label_position.dart';
import 'helpers/chart_style_builder.dart';
import 'helpers/axis_style_builder.dart';
import 'helpers/legend_style_builder.dart';
import 'internal/chart_title.dart';
import 'internal/chart_legend.dart';
import 'internal/chart_empty.dart';
import 'internal/chart_loading.dart';

/// A bar chart widget with consistent styling.
///
/// This widget provides a standardized bar chart that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppBarChart(
///   data: [
///     BarChartData(label: 'Jan', value: 10),
///     BarChartData(label: 'Feb', value: 15),
///     BarChartData(label: 'Mar', value: 12),
///   ],
///   title: 'Monthly Expenses',
/// )
/// ```
class AppBarChart extends StatelessWidget {
  /// The data for the bar chart.
  final List<BarChartData> data;

  /// The title of the chart.
  final String? title;

  /// The subtitle of the chart.
  final String? subtitle;

  /// The color of the bars.
  final Color? barColor;

  /// Whether the chart is horizontal.
  final bool isHorizontal;

  /// Whether to show grid lines.
  final bool showGrid;

  /// The position of the legend.
  final ChartLegendPosition legendPosition;

  /// Whether the chart is loading.
  final bool isLoading;

  /// Whether the chart is empty.
  final bool isEmpty;

  /// The animation duration.
  final Duration animationDuration;

  /// Creates a new [AppBarChart].
  const AppBarChart({
    super.key,
    required this.data,
    this.title,
    this.subtitle,
    this.barColor,
    this.isHorizontal = false,
    this.showGrid = true,
    this.legendPosition = ChartLegendPosition.none,
    this.isLoading = false,
    this.isEmpty = false,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = ChartStyleBuilder.build(
      context: context,
      type: ChartType.bar,
    );

    final effectiveBarColor = barColor ?? colorScheme.primary;

    if (isLoading) {
      return ChartLoading();
    }

    if (isEmpty || data.isEmpty) {
      return ChartEmpty();
    }

    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChartTitle(
          title: title,
          subtitle: subtitle,
          style: style,
        ),
        SizedBox(
          height: isHorizontal ? 250 : 200,
          child: BarChart(
            isHorizontal
                ? BarChartData(
                    barGroups: data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarRodData(
                            toY: item.value,
                            color: effectiveBarColor,
                            width: 16,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    gridData: FlGridData(
                      show: showGrid,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: style.gridColor,
                          strokeWidth: 0.5,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: AxisStyleBuilder.build(
                                context: context,
                                showGrid: showGrid,
                              ).labelStyle,
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < data.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  data[index].label,
                                  style: AxisStyleBuilder.build(
                                    context: context,
                                    showGrid: showGrid,
                                  ).labelStyle,
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: style.axisColor, width: 1),
                        left: BorderSide(color: style.axisColor, width: 1),
                      ),
                    ),
                  )
                : BarChartData(
                    barGroups: data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarRodData(
                            toY: item.value,
                            color: effectiveBarColor,
                            width: 16,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    gridData: FlGridData(
                      show: showGrid,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: style.gridColor,
                          strokeWidth: 0.5,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: AxisStyleBuilder.build(
                                context: context,
                                showGrid: showGrid,
                              ).labelStyle,
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < data.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  data[index].label,
                                  style: AxisStyleBuilder.build(
                                    context: context,
                                    showGrid: showGrid,
                                  ).labelStyle,
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: style.axisColor, width: 1),
                        left: BorderSide(color: style.axisColor, width: 1),
                      ),
                    ),
                  ),
            duration: animationDuration,
            curve: Curves.easeInOut,
          ),
        ),
        if (legendPosition != ChartLegendPosition.none)
          ChartLegend(
            items: [
              ChartLegendItem(
                label: title ?? 'Data',
                color: effectiveBarColor,
              ),
            ],
            position: legendPosition,
            style: LegendStyleBuilder.build(
              context: context,
              position: legendPosition,
            ),
          ),
      ],
    );
  }
}

/// A data point for the bar chart.
class BarChartData {
  /// The label of the bar.
  final String label;

  /// The value of the bar.
  final double value;

  /// Creates a new [BarChartData].
  const BarChartData({
    required this.label,
    required this.value,
  });
}
