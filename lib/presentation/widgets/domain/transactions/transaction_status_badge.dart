// lib/presentation/widgets/domain/transactions/transaction_status_badge.dart

import 'package:flutter/material.dart';

import '../../badges/app_badge.dart';
import '../../badges/enums/badge_variant.dart';
import '../../badges/enums/badge_size.dart';
import '../../badges/enums/badge_shape.dart';

/// A badge for displaying transaction status.
///
/// This widget provides a standardized transaction status badge for the
/// Family Finance Manager application.
///
/// Example:
/// ```dart
/// TransactionStatusBadge(
///   status: 'Completed',
/// )
/// ```
class TransactionStatusBadge extends StatelessWidget {
  /// The status text.
  final String status;

  /// The size of the badge.
  final BadgeSize size;

  /// Creates a new [TransactionStatusBadge].
  const TransactionStatusBadge({
    super.key,
    required this.status,
    this.size = BadgeSize.small,
  });

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      label: status,
      variant: _getStatusVariant(status),
      size: size,
      shape: BadgeShape.pill,
    );
  }

  BadgeVariant _getStatusVariant(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('completed') || lower.contains('approved')) {
      return BadgeVariant.success;
    }
    if (lower.contains('pending')) {
      return BadgeVariant.warning;
    }
    if (lower.contains('failed') || lower.contains('cancelled')) {
      return BadgeVariant.error;
    }
    return BadgeVariant.neutral;
  }
}
