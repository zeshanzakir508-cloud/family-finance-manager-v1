// lib/domain/value_objects/notification_metadata.dart

import 'package:equatable/equatable.dart';

import '../enums/notification_source.dart';
import '../enums/notification_category.dart';
import 'notification_custom_metadata.dart';

/// Value object representing notification metadata.
class NotificationMetadata extends Equatable {
  /// Source of the notification.
  final NotificationSource? source;

  /// Category of the notification.
  final NotificationCategory? category;

  /// Tags associated with the notification.
  final List<String>? tags;

  /// Additional custom metadata.
  final NotificationCustomMetadata? customData;

  const NotificationMetadata({
    this.source,
    this.category,
    this.tags,
    this.customData,
  });

  /// Creates a copy of this notification metadata with the given fields replaced.
  NotificationMetadata copyWith({
    NotificationSource? source,
    NotificationCategory? category,
    List<String>? tags,
    NotificationCustomMetadata? customData,
  }) {
    return NotificationMetadata(
      source: source ?? this.source,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      customData: customData ?? this.customData,
    );
  }

  /// Returns true if any metadata is present.
  bool get hasContent =>
      source != null ||
      category != null ||
      (tags != null && tags!.isNotEmpty) ||
      (customData != null && customData!.hasContent);

  @override
  List<Object?> get props => [
        source,
        category,
        tags,
        customData,
      ];
}
