// lib/presentation/widgets/charts/app_pie_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'enums/chart_type.dart';
import 'enums/chart_animation.dart';
import 'enums/chart_legend_position.dart';
import 'helpers/chart_style_builder.dart';
import 'helpers/legend_style_builder.dart';
import 'internal/chart_title.dart';
import 'internal/chart_legend.dart';
import 'internal/chart_empty.dart';
import 'internal/chart_loading.dart';

/// A pie chart widget with consistent styling.
///
/// This widget provides a standardized pie chart that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppPieChart(
///   data: [
///     PieChartData(label: 'Food', value: 30, color: Colors.blue),
///     PieChartData(label: 'Transport', value: 20, color: Colors.green),
///     PieChartData(label: 'Shopping', value: 15, color: Colors.orange),
///   ],
///   title: 'Expense Breakdown',
/// )
/// ```
class AppPieChart extends StatelessWidget {
  /// The data for the pie chart.
  final List<PieChartData> data;

  /// The title of the chart.
  final String? title;

  /// The subtitle of the chart.
  final String? subtitle;

  /// The position of the legend.
  final ChartLegendPosition legendPosition;

  /// The radius of the pie chart.
  final double radius;

  /// Whether the chart is loading.
  final bool isLoading;

  /// Whether the chart is empty.
  final bool isEmpty;

  /// The animation duration.
  final Duration animationDuration;

  /// Creates a new [AppPieChart].
  const AppPieChart({
    super.key,
    required this.data,
    this.title,
    this.subtitle,
    this.legendPosition = ChartLegendPosition.right,
    this.radius = 80,
    this.isLoading = false,
    this.isEmpty = false,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    final style = ChartStyleBuilder.build(
      context: context,
      type: ChartType.pie,
    );

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
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: radius * 2 + 40,
                child: PieChart(
                  PieChartData(
                    sections: data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return PieChartSectionData(
                        value: item.value,
                        color: item.color,
                        radius: radius,
                        showTitle: false,
                        title: item.label,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 0,
                    startDegreeOffset: -90,
                  ),
                  duration: animationDuration,
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          ],
        ),
        if (legendPosition != ChartLegendPosition.none)
          ChartLegend(
            items: data.map((item) {
              return ChartLegendItem(
                label: '${item.label} (${item.value.toInt()}%)',
                color: item.color,
              );
            }).toList(),
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

/// A data point for the pie chart.
class PieChartData {
  /// The label of the segment.
  final String label;

  /// The value of the segment (percentage).
  final double value;

  /// The color of the segment.
  final Color color;

  /// Creates a new [PieChartData].
  const PieChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}
