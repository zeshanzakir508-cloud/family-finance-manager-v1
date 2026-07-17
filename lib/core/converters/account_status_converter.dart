import 'package:json_annotation/json_annotation.dart';

import '../enums/account_status.dart';

class AccountStatusConverter
    implements JsonConverter<AccountStatus, String> {
  const AccountStatusConverter();

  @override
  AccountStatus fromJson(String json) =>
      AccountStatusExtension.fromValue(json);

  @override
  String toJson(AccountStatus object) => object.value;
}
