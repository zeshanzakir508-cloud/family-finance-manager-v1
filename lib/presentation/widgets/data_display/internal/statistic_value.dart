// lib/presentation/widgets/data_display/internal/statistic_value.dart

import 'package:flutter/material.dart';

import '../helpers/statistic_style_builder.dart';

/// Internal widget for rendering statistic value with optional icon.
class StatisticValue extends StatelessWidget {
  final String value;
  final String? label;
  final StatisticStyle style;
  final Widget? leading;

  const StatisticValue({
    super.key,
    required this.value,
    this.label,
    required this.style,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (leading != null) {
      children.add(leading!);
      children.add(const SizedBox(width: 8));
    }

    children.add(
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: style.valueStyle,
            ),
            if (label != null) ...[
              const SizedBox(height: 4),
              Text(
                label!,
                style: style.labelStyle,
              ),
            ],
          ],
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
