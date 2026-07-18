import '../../../models/notification_model.dart';

/// Request object for creating a notification.
class CreateNotificationRequest {
  final NotificationModel notification;

  const CreateNotificationRequest({
    required this.notification,
  });
}
