import 'package:json_annotation/json_annotation.dart';

import '../enums/notification_type.dart';

class NotificationTypeConverter
    implements JsonConverter<NotificationType, String> {
  const NotificationTypeConverter();

  @override
  NotificationType fromJson(String json) =>
      NotificationTypeExtension.fromValue(json);

  @override
  String toJson(NotificationType object) => object.value;
}
