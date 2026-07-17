import 'package:json_annotation/json_annotation.dart';

import '../enums/transaction_type.dart';

class TransactionTypeConverter
    implements JsonConverter<TransactionType, String> {
  const TransactionTypeConverter();

  @override
  TransactionType fromJson(String json) =>
      TransactionTypeExtension.fromValue(json);

  @override
  String toJson(TransactionType object) => object.value;
}
