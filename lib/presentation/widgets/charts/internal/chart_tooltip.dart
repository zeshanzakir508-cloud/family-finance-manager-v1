// lib/presentation/widgets/charts/internal/chart_tooltip.dart

import 'package:flutter/material.dart';

import '../helpers/tooltip_style_builder.dart';

/// Internal widget for rendering chart tooltip.
class ChartTooltip extends StatelessWidget {
  final String label;
  final String value;
  final TooltipStyle style;

  const ChartTooltip({
    super.key,
    required this.label,
    required this.value,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: style.padding,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: style.borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: style.elevation,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: style.textStyle,
          ),
          Text(
            value,
            style: style.textStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
