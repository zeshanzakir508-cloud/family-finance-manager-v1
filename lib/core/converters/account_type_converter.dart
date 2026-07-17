import 'package:json_annotation/json_annotation.dart';

import '../enums/account_type.dart';

class AccountTypeConverter implements JsonConverter<AccountType, String> {
  const AccountTypeConverter();

  @override
  AccountType fromJson(String json) =>
      AccountTypeExtension.fromValue(json);

  @override
  String toJson(AccountType object) => object.value;
}
