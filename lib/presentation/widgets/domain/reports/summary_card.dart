// lib/presentation/widgets/domain/reports/summary_card.dart

import 'package:flutter/material.dart';

import '../../cards/app_card.dart';
import '../../cards/enums/card_variant.dart';
import '../../cards/enums/card_elevation.dart';
import '../../data_display/app_counter.dart';

/// A summary card for report statistics.
///
/// This widget provides a standardized summary card for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// SummaryCard(
///   count: 245,
///   label: 'Transactions',
///   icon: Icons.receipt,
///   color: Colors.blue,
/// )
/// ```
class SummaryCard extends StatelessWidget {
  /// The count value.
  final int count;

  /// The label text.
  final String label;

  /// The optional icon.
  final IconData? icon;

  /// The color of the count.
  final Color? color;

  /// The subtitle (optional).
  final String? subtitle;

  /// Creates a new [SummaryCard].
  const SummaryCard({
    super.key,
    required this.count,
    required this.label,
    this.icon,
    this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: CardVariant.filled,
      elevation: CardElevation.low,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       
