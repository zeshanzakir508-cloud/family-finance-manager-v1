// lib/presentation/widgets/charts/app_line_chart.dart

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

/// A line chart widget with consistent styling.
///
/// This widget provides a standardized line chart that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppLineChart(
///   data: [
///     LineChartDataPoint(x: 1, y: 10),
///     LineChartDataPoint(x: 2, y: 15),
///     LineChartDataPoint(x: 3, y: 12),
///   ],
///   title: 'Monthly Trend',
///   showGrid: true,
/// )
/// ```
class AppLineChart extends StatelessWidget {
  /// The data points for the line chart.
  final List<LineChartDataPoint> data;

  /// The title of the chart.
  final String? title;

  /// The subtitle of the chart.
  final String? subtitle;

  /// The color of the line.
  final Color? lineColor;

  /// The color of the area fill.
  final Color? fillColor;

  /// Whether to show grid lines.
  final bool showGrid;

  /// The position of the legend.
  final ChartLegendPosition legendPosition;

  /// Whether the chart is loading.
  final bool isLoading;

  /// Whether the chart is empty.
  final bool isEmpty;

  /// The animation type.
  final ChartAnimation animation;

  /// The animation duration.
  final Duration animationDuration;

  /// Creates a new [AppLineChart].
  const AppLineChart({
    super.key,
    required this.data,
    this.title,
    this.subtitle,
    this.lineColor,
    this.fillColor,
    this.showGrid = true,
    this.legendPosition = ChartLegendPosition.none,
    this.isLoading = false,
    this.isEmpty = false,
    this.animation = ChartAnimation.fade,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = ChartStyleBuilder.build(
      context: context,
      type: ChartType.line,
    );

    final effectiveLineColor = lineColor ?? colorScheme.primary;
    final effectiveFillColor = fillColor ?? effectiveLineColor.withOpacity(0.2);

    if (isLoading) {
      return ChartLoading();
    }

    if (isEmpty || data.isEmpty) {
      return ChartEmpty();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChartTitle(
          title: title,
          subtitle: subtitle,
          style: style,
        ),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: data.map((point) => FlSpot(point.x, point.y)).toList(),
                  isCurved: true,
                  color: effectiveLineColor,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: fillColor != null,
                    color: effectiveFillColor,
                  ),
                ),
              ],
              gridData: FlGridData(
                show: showGrid,
                drawVerticalLine: false,
                horizontalInterval: _getHorizontalInterval(data),
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
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
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
                color: effectiveLineColor,
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

  double _getHorizontalInterval(List<LineChartDataPoint> data) {
    if (data.isEmpty) return 1;
    final maxY = data.map((p) => p.y).reduce((a, b) => a > b ? a : b);
    if (maxY <= 10) return 1;
    if (maxY <= 50) return 5;
    if (maxY <= 100) return 10;
    return 25;
  }
}

/// A data point for the line chart.
class LineChartDataPoint {
  /// The x value.
  final double x;

  /// The y value.
  final double y;

  /// Creates a new [LineChartDataPoint].
  const LineChartDataPoint({
    required this.x,
    required this.y,
  });
}
