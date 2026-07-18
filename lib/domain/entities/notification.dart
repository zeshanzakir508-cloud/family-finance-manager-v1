// lib/domain/entities/notification.dart

import 'package:equatable/equatable.dart';

import '../enums/notification_type.dart';
import '../enums/notification_priority.dart';
import '../value_objects/notification_data.dart';

/// Notification entity representing a user notification.
///
/// This entity tracks notifications sent to users, including
/// read status, priority, and expiration.
class Notification extends Equatable {
  /// Unique identifier for the notification.
  /// Set by the persistence layer (Repository/DataSource).
  final String? id;

  /// ID of the user who receives this notification.
  final String userId;

  /// Title of the notification.
  final String title;

  /// Body/content of the notification.
  final String body;

  /// Type of notification.
  final NotificationType type;

  /// Whether the notification has been read.
  final bool isRead;

  /// Date when the notification was read (if read).
  final DateTime? readAt;

  /// Additional data payload for the notification.
  final NotificationData data;

  /// URL to an image (optional).
  final String? imageUrl;

  /// URL to navigate when the notification is tapped (optional).
  final String? actionUrl;

  /// ID of the user who sent the notification (optional).
  final String? senderId;

  /// Name of the user who sent the notification (optional).
  final String? senderName;

  /// ID of the family this notification belongs to (optional).
  final String? familyId;

  /// Priority of the notification.
  final NotificationPriority priority;

  /// Category of the notification (optional).
  final String? category;

  /// Date when the notification expires (optional).
  final DateTime? expiresAt;

  const Notification({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    this.readAt,
    this.data = const NotificationData(),
    this.imageUrl,
    this.actionUrl,
    this.senderId,
    this.senderName,
    this.familyId,
    this.priority = NotificationPriority.normal,
    this.category,
    this.expiresAt,
  });

  /// Creates a copy of this notification with the given fields replaced.
  Notification copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? readAt,
    NotificationData? data,
    String? imageUrl,
    String? actionUrl,
    String? senderId,
    String? senderName,
    String? familyId,
    NotificationPriority? priority,
    String? category,
    DateTime? expiresAt,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      familyId: familyId ?? this.familyId,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  /// Marks the notification as read at the given time.
  Notification markAsRead(DateTime readTime) {
    if (isRead) return this;
    return copyWith(
      isRead: true,
      readAt: readTime,
    );
  }

  /// Marks the notification as unread.
  Notification markAsUnread() {
    if (!isRead) return this;
    return copyWith(
      isRead: false,
      readAt: null,
    );
  }

  /// Checks if the notification has expired at the given time.
  bool isExpiredAt(DateTime currentTime) {
    if (expiresAt == null) return false;
    return currentTime.isAfter(expiresAt!);
  }

  /// Checks if the notification is a high priority notification.
  bool get isHighPriority => priority == NotificationPriority.high;

  /// Checks if the notification is a low priority notification.
  bool get isLowPriority => priority == NotificationPriority.low;

  /// Checks if the notification is from a family member.
  bool get isFromFamily => familyId != null && senderId != null;

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        body,
        type,
        isRead,
        readAt,
        data,
        imageUrl,
        actionUrl,
        senderId,
        senderName,
        familyId,
        priority,
        category,
        expiresAt,
      ];
}
