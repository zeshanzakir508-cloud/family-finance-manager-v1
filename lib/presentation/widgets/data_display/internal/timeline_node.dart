// lib/presentation/widgets/data_display/internal/timeline_node.dart

import 'package:flutter/material.dart';

import '../helpers/timeline_style_builder.dart';

/// Internal widget for rendering a timeline node.
class TimelineNode extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final TimelineStyle style;
  final Color? color;

  const TimelineNode({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.style,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final nodeColor = color ?? style.nodeColor;

    return SizedBox(
      width: style.nodeSize + style.spacing,
      child: Column(
        children: [
          if (!isFirst)
            Container(
              width: style.lineWidth,
              height: style.spacing / 2,
              color: style.lineColor,
            ),
          Container(
            width: style.nodeSize,
            height: style.nodeSize,
            decoration: BoxDecoration(
              color: nodeColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: style.lineWidth,
                color: style.lineColor,
              ),
            ),
        ],
      ),
    );
  }
}
