/// Request object for marking a notification as unread.
class MarkAsUnreadRequest {
  final String notificationId;

  const MarkAsUnreadRequest({
    required this.notificationId,
  });
}
