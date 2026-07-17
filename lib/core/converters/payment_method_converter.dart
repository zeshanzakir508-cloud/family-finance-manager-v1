import 'package:json_annotation/json_annotation.dart';

import '../enums/payment_method.dart';

class PaymentMethodConverter
    implements JsonConverter<PaymentMethod, String> {
  const PaymentMethodConverter();

  @override
  PaymentMethod fromJson(String json) =>
      PaymentMethodExtension.fromValue(json);

  @override
  String toJson(PaymentMethod object) => object.value;
}
