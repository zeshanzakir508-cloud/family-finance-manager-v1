// lib/presentation/widgets/domain/transactions/transaction_timeline.dart

import 'package:flutter/material.dart';

import '../../data_display/app_timeline.dart';
import '../../data_display/enums/timeline_variant.dart';

/// A timeline for transaction history.
///
/// This widget provides a standardized transaction timeline for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// TransactionTimeline(
///   items: [
///     TimelineItem(label: 'Created', time: '10:00 AM'),
///     TimelineItem(label: 'Updated', time: '11:30 AM'),
///     TimelineItem(label: 'Completed', time: '2:00 PM'),
///   ],
/// )
/// ```
class TransactionTimeline extends StatelessWidget {
  /// The timeline items.
  final List<TimelineItem> items;

  /// The variant of the timeline.
  final TimelineVariant variant;

  /// Creates a new [TransactionTimeline].
  const TransactionTimeline({
    super.key,
    required this.items,
    this.variant = TimelineVariant.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return AppTimeline(
      items: items,
      variant: variant,
    );
  }
}
