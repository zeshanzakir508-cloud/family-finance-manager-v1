// lib/presentation/widgets/charts/internal/chart_title.dart

import 'package:flutter/material.dart';

import '../helpers/chart_style_builder.dart';

/// Internal widget for rendering chart title and subtitle.
class ChartTitle extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final ChartStyle style;

  const ChartTitle({
    super.key,
    this.title,
    this.subtitle,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null && title!.isNotEmpty;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;

    if (!hasTitle && !hasSubtitle) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTitle)
            Text(
              title!,
              style: style.titleStyle,
            ),
          if (hasTitle && hasSubtitle)
            const SizedBox(height: 2),
          if (hasSubtitle)
            Text(
              subtitle!,
              style: style.subtitleStyle,
            ),
        ],
      ),
    );
  }
}
