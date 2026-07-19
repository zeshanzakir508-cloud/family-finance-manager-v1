// lib/presentation/widgets/charts/internal/chart_empty.dart

import 'package:flutter/material.dart';

import '../../feedback/app_empty_state.dart';
import '../../feedback/enums/feedback_type.dart';

/// Internal widget for rendering empty chart state.
class ChartEmpty extends StatelessWidget {
  final String? message;

  const ChartEmpty({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: 'No Data Available',
      message: message ?? 'There is no data to display in this chart.',
      type: FeedbackType.info,
    );
  }
}
