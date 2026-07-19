// lib/presentation/widgets/charts/internal/chart_legend.dart

import 'package:flutter/material.dart';

import '../enums/chart_legend_position.dart';
import '../helpers/legend_style_builder.dart';

/// Internal widget for rendering chart legend.
class ChartLegend extends StatelessWidget {
  final List<ChartLegendItem> items;
  final ChartLegendPosition position;
  final LegendStyle style;

  const ChartLegend({
    super.key,
    required this.items,
    required this.position,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (position == ChartLegendPosition.none || items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: style.padding,
      child: Wrap(
        spacing: style.spacing,
        runSpacing: style.runSpacing,
        alignment: WrapAlignment.center,
        children: items.map((item) {
          return _LegendItem(
            item: item,
            style: style,
          );
        }).toList(),
      ),
    );
  }
}

/// A legend item.
class ChartLegendItem {
  /// The label text.
  final String label;

  /// The color of the legend item.
  final Color color;

  /// Creates a new [ChartLegendItem].
  const ChartLegendItem({
    required this.label,
    required this.color,
  });
}

/// Internal widget for a single legend item.
class _LegendItem extends StatelessWidget {
  final ChartLegendItem item;
  final LegendStyle style;

  const _LegendItem({
    required this.item,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: style.itemSize,
          height: style.itemSize,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: style.borderRadius,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          item.label,
          style: style.textStyle,
        ),
      ],
    );
  }
}
