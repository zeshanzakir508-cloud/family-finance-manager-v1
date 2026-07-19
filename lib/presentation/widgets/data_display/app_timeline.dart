// lib/presentation/widgets/data_display/app_timeline.dart

import 'package:flutter/material.dart';

import '../cards/app_card.dart';
import '../cards/enums/card_variant.dart';
import '../cards/enums/card_elevation.dart';
import 'enums/timeline_variant.dart';
import 'helpers/timeline_style_builder.dart';
import 'internal/timeline_node.dart';

/// A timeline widget for displaying chronological events.
///
/// This widget provides a standardized timeline that follows the
/// application's design system.
///
/// Example:
/// ```dart
/// AppTimeline(
///   items: [
///     TimelineItem(label: 'Created', time: '10:00 AM'),
///     TimelineItem(label: 'Updated', time: '11:30 AM'),
///     TimelineItem(label: 'Approved', time: '2:00 PM'),
///   ],
/// )
/// ```
class AppTimeline extends StatelessWidget {
  /// The list of timeline items.
  final List<TimelineItem> items;

  /// The visual variant of the timeline.
  final TimelineVariant variant;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Creates a new [AppTimeline].
  const AppTimeline({
    super.key,
    required this.items,
    this.variant = TimelineVariant.vertical,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = TimelineStyleBuilder.build(
      context: context,
      variant: variant,
    );

    if (variant == TimelineVariant.vertical) {
      return _buildVerticalTimeline(context, style);
    }

    return _buildHorizontalTimeline(context, style);
  }

  Widget _buildVerticalTimeline(BuildContext context, TimelineStyle style) {
    return AppCard(
      variant: CardVariant.filled,
      elevation: CardElevation.low,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isFirst = index == 0;
          final isLast = index == items.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimelineNode(
                isFirst: isFirst,
                isLast: isLast,
                style: style,
                color: item.color,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : style.spacing,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: style.textStyle,
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                      if (item.time != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.time!,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHorizontalTimeline(BuildContext context, TimelineStyle style) {
    return AppCard(
      variant: CardVariant.filled,
      elevation: CardElevation.low,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isFirst = index == 0;
            final isLast = index == items.length - 1;

            return Row(
              children: [
                if (!isFirst)
                  Container(
                    width: style.spacing,
                    height: style.lineWidth,
                    color: style.lineColor,
                  ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: style.nodeSize,
                      height: style.nodeSize,
                      decoration: BoxDecoration(
                        color: item.color ?? style.nodeColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.label,
                      style: style.textStyle,
                    ),
                    if (item.time != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.time!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
                if (isLast) const SizedBox(width: 0),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// A timeline item.
class TimelineItem {
  /// The label text.
  final String label;

  /// The optional subtitle text.
  final String? subtitle;

  /// The optional time text.
  final String? time;

  /// The optional color of the timeline node.
  final Color? color;

  /// Creates a new [TimelineItem].
  const TimelineItem({
    required this.label,
    this.subtitle,
    this.time,
    this.color,
  });
}
