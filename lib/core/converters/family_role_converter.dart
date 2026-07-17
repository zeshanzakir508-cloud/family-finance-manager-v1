import 'package:json_annotation/json_annotation.dart';

import '../enums/family_role.dart';

class FamilyRoleConverter implements JsonConverter<FamilyRole, String> {
  const FamilyRoleConverter();

  @override
  FamilyRole fromJson(String json) => FamilyRoleExtension.fromValue(json);

  @override
  String toJson(FamilyRole object) => object.value;
}
