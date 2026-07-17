import 'package:json_annotation/json_annotation.dart';

import '../enums/activity_type.dart';

class ActivityTypeConverter
    implements JsonConverter<ActivityType, String> {
  const ActivityTypeConverter();

  @override
  ActivityType fromJson(String json) =>
      ActivityTypeExtension.fromValue(json);

  @override
  String toJson(ActivityType object) => object.value;
}
