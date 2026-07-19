// lib/presentation/widgets/charts/app_chart_card.dart

import 'package:flutter/material.dart';

import '../cards/app_card.dart';
import '../cards/enums/card_variant.dart';
import '../cards/enums/card_elevation.dart';

/// A card wrapper for charts with consistent styling.
///
/// This widget provides a standardized card wrapper for charts that
/// follows the application's design system.
///
/// Example:
/// ```dart
/// AppChartCard(
///   child: AppLineChart(data: data),
///   title: 'Monthly Trend',
///   action: IconButton(...),
/// )
/// ```
class AppChartCard extends StatelessWidget {
  /// The chart widget.
  final Widget child;

  /// The title of the chart card.
  final String? title;

  /// The action widget (e.g., filter button).
  final Widget? action;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom padding override.
  final EdgeInsetsGeometry? padding;

  /// Creates a new [AppChartCard].
  const AppChartCard({
    super.key,
    required this.child,
    this.title,
    this.action,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: CardVariant.filled,
      elevation: CardElevation.low,
      backgroundColor: backgroundColor,
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || action != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                if (action != null) action!,
              ],
            ),
          if (title != null || action != null)
            const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
