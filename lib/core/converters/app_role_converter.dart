import 'package:json_annotation/json_annotation.dart';

import '../enums/app_role.dart';

class AppRoleConverter implements JsonConverter<AppRole, String> {
  const AppRoleConverter();

  @override
  AppRole fromJson(String json) => AppRoleExtension.fromValue(json);

  @override
  String toJson(AppRole object) => object.value;
}
