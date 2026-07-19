// lib/presentation/widgets/charts/app_sparkline.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'enums/chart_type.dart';
import 'enums/chart_animation.dart';
import 'helpers/chart_style_builder.dart';

/// A sparkline widget for mini trend indicators.
///
/// This widget provides a standardized sparkline that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppSparkline(
///   data: [10, 15, 12, 18, 14, 20, 22],
///   color: Colors.green,
///   height: 40,
/// )
/// ```
class AppSparkline extends StatelessWidget {
  /// The data points for the sparkline.
  final List<double> data;

  /// The color of the sparkline.
  final Color? color;

  /// The height of the sparkline.
  final double height;

  /// The width of the sparkline.
  final double? width;

  /// Whether to show the area fill.
  final bool showArea;

  /// The animation duration.
  final Duration animationDuration;

  /// Creates a new [AppSparkline].
  const AppSparkline({
    super.key,
    required this.data,
    this.color,
    this.height = 40,
    this.width,
    this.showArea = true,
    this.animationDuration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? colorScheme.primary;
    final effectiveFillColor = effectiveColor.withOpacity(0.2);

    if (data.isEmpty) {
      return SizedBox(
        height: height,
        width: width,
      );
    }

    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    final hasVariation = range > 0;

    final spots = data.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      return FlSpot(index.toDouble(), value);
    }).toList();

    return SizedBox(
      height: height,
      width: width,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: effectiveColor,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: showArea && hasVariation,
                color: effectiveFillColor,
              ),
            ),
          ],
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: hasVariation ? minY - range * 0.1 : minY - 1,
          maxY: hasVariation ? maxY + range * 0.1 : maxY + 1,
        ),
        duration: animationDuration,
        curve: Curves.easeInOut,
      ),
    );
  }
}
