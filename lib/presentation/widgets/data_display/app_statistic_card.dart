// lib/presentation/widgets/data_display/app_statistic_card.dart

import 'package:flutter/material.dart';

import '../cards/app_card.dart';
import '../cards/enums/card_variant.dart';
import '../cards/enums/card_elevation.dart';
import 'enums/statistic_variant.dart';
import 'helpers/statistic_style_builder.dart';
import 'internal/statistic_value.dart';

/// A statistic card with consistent styling.
///
/// This widget provides a standardized statistic card that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppStatisticCard(
///   value: '\$12,450',
///   label: 'Total Balance',
///   variant: StatisticVariant.success,
///   leading: Icon(Icons.wallet),
/// )
/// ```
class AppStatisticCard extends StatelessWidget {
  /// The value text to display.
  final String value;

  /// The label text to display.
  final String? label;

  /// The visual variant of the statistic.
  final StatisticVariant variant;

  /// The leading widget.
  final Widget? leading;

  /// The trailing widget.
  final Widget? trailing;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Creates a new [AppStatisticCard].
  const AppStatisticCard({
    super.key,
    required this.value,
    this.label,
    this.variant = StatisticVariant.neutral,
    this.leading,
    this.trailing,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = StatisticStyleBuilder.build(
      context: context,
      variant: variant,
    );

    final bgColor = backgroundColor ?? style.backgroundColor;

    return AppCard(
      variant: CardVariant.filled,
      elevation: CardElevation.low,
      backgroundColor: bgColor,
      padding: style.padding,
      child: Row(
        children: [
          Expanded(
            child: StatisticValue(
              value: value,
              label: label,
              style: style,
              leading: leading,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
