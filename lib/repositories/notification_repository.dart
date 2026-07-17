import '../models/notification_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Notification Repository
/// ----------------------------------------------------------------------------
/// Defines the contract for managing user notifications.
///
/// Responsibilities:
/// • Create notifications
/// • Read notification(s)
/// • Update notifications
/// • Soft delete notifications
/// • Restore notifications
/// • Watch notification changes
/// • Mark notifications as read/unread
/// • Notification statistics
///
/// NOTE:
/// This file only defines the repository contract.
/// Firebase implementation will be provided later.
/// ============================================================================

abstract class NotificationRepository {
  //==========================================================================
  // Notification
  //==========================================================================

  /// Creates a new notification.
  Future<void> createNotification(NotificationModel notification);

  /// Returns a notification by its ID.
  Future<NotificationModel?> getNotification(String notificationId);

  /// Returns all notifications for a user.
  Future<List<NotificationModel>> getNotifications(String userId);

  /// Watches a notification.
  Stream<NotificationModel?> watchNotification(
    String notificationId,
  );

  /// Watches all notifications for a user.
  Stream<List<NotificationModel>> watchNotifications(
    String userId,
  );

  /// Updates an existing notification.
  Future<void> updateNotification(
    NotificationModel notification,
  );

  /// Soft deletes a notification.
  Future<void> deleteNotification(
    String notificationId,
  );

  /// Restores a deleted notification.
  Future<void> restoreNotification(
    String notificationId,
  );

  /// Returns true if the notification exists.
  Future<bool> notificationExists(
    String notificationId,
  );

  //==========================================================================
  // Read Status
  //==========================================================================

  /// Marks a notification as read.
  Future<void> markAsRead(
    String notificationId,
  );

  /// Marks a notification as unread.
  Future<void> markAsUnread(
    String notificationId,
  );

  /// Marks all notifications as read.
  Future<void> markAllAsRead(
    String userId,
  );

  /// Deletes all notifications for a user.
  Future<void> deleteAllNotifications(
    String userId,
  );

  /// Returns unread notification count.
  Future<int> getUnreadCount(
    String userId,
  );

  /// Watches unread notification count.
  Stream<int> watchUnreadCount(
    String userId,
  );
}
