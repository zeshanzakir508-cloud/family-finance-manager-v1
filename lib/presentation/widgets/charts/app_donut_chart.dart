// lib/presentation/widgets/charts/app_donut_chart.dart

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

/// A donut chart widget with consistent styling.
///
/// This widget provides a standardized donut chart that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppDonutChart(
///   data: [
///     PieChartData(label: 'Food', value: 30, color: Colors.blue),
///     PieChartData(label: 'Transport', value: 20, color: Colors.green),
///     PieChartData(label: 'Shopping', value: 15, color: Colors.orange),
///   ],
///   centerLabel: 'Total',
///   centerValue: 'PKR 65,000',
///   title: 'Expense Breakdown',
/// )
/// ```
class AppDonutChart extends StatelessWidget {
  /// The data for the donut chart.
  final List<PieChartData> data;

  /// The title of the chart.
  final String? title;

  /// The subtitle of the chart.
  final String? subtitle;

  /// The center label text.
  final String? centerLabel;

  /// The center value text.
  final String? centerValue;

  /// The position of the legend.
  final ChartLegendPosition legendPosition;

  /// The radius of the donut chart.
  final double radius;

  /// The radius of the center hole.
  final double centerSpaceRadius;

  /// Whether the chart is loading.
  final bool isLoading;

  /// Whether the chart is empty.
  final bool isEmpty;

  /// The animation duration.
  final Duration animationDuration;

  /// Creates a new [AppDonutChart].
  const AppDonutChart({
    super.key,
    required this.data,
    this.title,
    this.subtitle,
    this.centerLabel,
    this.centerValue,
    this.legendPosition = ChartLegendPosition.right,
    this.radius = 80,
    this.centerSpaceRadius = 40,
    this.isLoading = false,
    this.isEmpty = false,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = ChartStyleBuilder.build(
      context: context,
      type: ChartType.donut,
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sections: data.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return PieChartSectionData(
                            value: item.value,
                            color: item.color,
                            radius: radius,
                            showTitle: false,
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: centerSpaceRadius,
                        startDegreeOffset: -90,
                      ),
                      duration: animationDuration,
                      curve: Curves.easeInOut,
                    ),
                    if (centerValue != null || centerLabel != null)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (centerValue != null)
                            Text(
                              centerValue!,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          if (centerLabel != null)
                            Text(
                              centerLabel!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                        ],
                      ),
                  ],
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
