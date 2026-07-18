// lib/domain/value_objects/notification_extras.dart

import 'package:equatable/equatable.dart';

import '../enums/notification_priority.dart';
import '../enums/notification_status.dart';
import 'notification_metadata.dart';

/// Value object representing additional notification data.
///
/// Contains structured extra data that can be attached to a notification.
class NotificationExtras extends Equatable {
  /// Amount associated with the notification (if applicable).
  final double? amount;

  /// Status of the related entity (if applicable).
  final NotificationStatus? status;

  /// Priority level of the notification.
  final NotificationPriority? priority;

  /// Additional metadata for the notification.
  final NotificationMetadata? metadata;

  const NotificationExtras({
    this.amount,
    this.status,
    this.priority,
    this.metadata,
  });

  /// Creates a copy of these notification extras with the given fields replaced.
  NotificationExtras copyWith({
    double? amount,
    NotificationStatus? status,
    NotificationPriority? priority,
    NotificationMetadata? metadata,
  }) {
    return NotificationExtras(
      amount: amount ?? this.amount,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Returns true if any extra data is present.
  bool get hasContent =>
      amount != null ||
      status != null ||
      priority != null ||
      (metadata != null && metadata!.hasContent);

  /// Returns the priority level as a string (for display purposes).
  String? get priorityLabel => priority?.name;

  @override
  List<Object?> get props => [
        amount,
        status,
        priority,
        metadata,
      ];
}
