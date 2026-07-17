import 'package:json_annotation/json_annotation.dart';

import '../enums/subscription_status.dart';

class SubscriptionStatusConverter
    implements JsonConverter<SubscriptionStatus, String> {
  const SubscriptionStatusConverter();

  @override
  SubscriptionStatus fromJson(String json) =>
      SubscriptionStatusExtension.fromValue(json);

  @override
  String toJson(SubscriptionStatus object) => object.value;
}
