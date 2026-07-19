// lib/presentation/widgets/data_display/internal/data_label.dart

import 'package:flutter/material.dart';

import '../helpers/label_style_builder.dart';

/// Internal widget for rendering a data label.
class DataLabel extends StatelessWidget {
  final String text;
  final String variant;
  final LabelStyle style;

  const DataLabel({
    super.key,
    required this.text,
    required this.variant,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: style.padding,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: style.borderRadius,
      ),
      child: Text(
        text,
        style: style.textStyle,
      ),
    );
  }
}
