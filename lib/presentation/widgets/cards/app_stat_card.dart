import 'package:flutter/material.dart';

import 'app_card.dart';
import 'enums/card_elevation.dart';
import 'enums/card_variant.dart';

/// A specialized statistics card built on top of [AppCard].
///
/// This widget is intended for displaying dashboard statistics such as:
/// - Total Balance
/// - Income
/// - Expenses
/// - Savings
/// - Transactions
/// - Budget Progress
///
/// Example:
/// ```dart
/// AppStatCard(
///   title: 'Income',
///   value: 'PKR 125,000',
///   trend: '+12%',
///   trendColor: Colors.green,
///   leading: Icon(Icons.trending_up),
/// )
/// ```
class AppStatCard extends StatelessWidget {
  /// Leading widget displayed before the title.
  final Widget? leading;

  /// Statistic title.
  final String title;

  /// Main statistic value.
  final String value;

  /// Optional trend text.
  final String? trend;

  /// Optional trend widget.
  final Widget? trendWidget;

  /// Color of the trend text.
  final Color? trendColor;

  /// Trailing widget displayed in the header.
  final Widget? trailing;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Card visual variant.
  final CardVariant variant;

  /// Card elevation.
  final CardElevation elevation;

  /// Background color override.
  final Color? color;

  /// Content padding override.
  final EdgeInsetsGeometry? padding;

  /// Margin override.
  final EdgeInsetsGeometry? margin;

  /// Width override.
  final double? width;

  /// Height override.
  final double? height;

  /// Shape override.
  final ShapeBorder? shape;

  /// Border override.
  final BorderSide? border;

  /// Creates a new [AppStatCard].
  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    this.leading,
    this.trend,
    this.trendWidget,
    this.trendColor,
    this.trailing,
    this.onTap,
    this.variant = CardVariant.filled,
    this.elevation = CardElevation.low,
    this.color,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.shape,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      leading: leading,
      title: title,
      trailing: trailing,
      onTap: onTap,
      variant: variant,
      elevation: elevation,
      color: color,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      shape: shape,
      border: border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (trend != null || trendWidget != null) ...[
            const SizedBox(height: 8),
            trendWidget ??
                Text(
                  trend!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: trendColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ],
        ],
      ),
    );
  }
}
