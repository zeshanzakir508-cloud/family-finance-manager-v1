import '../../../models/notification_model.dart';

/// Request object for updating a notification.
class UpdateNotificationRequest {
  final NotificationModel notification;

  const UpdateNotificationRequest({
    required this.notification,
  });
}
