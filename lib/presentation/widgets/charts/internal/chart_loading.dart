// lib/presentation/widgets/charts/internal/chart_loading.dart

import 'package:flutter/material.dart';

import '../../feedback/app_loading_indicator.dart';
import '../../feedback/enums/loading_size.dart';

/// Internal widget for rendering chart loading state.
class ChartLoading extends StatelessWidget {
  const ChartLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppLoadingIndicator(
        size: LoadingSize.medium,
        label: 'Loading chart data...',
      ),
    );
  }
}
