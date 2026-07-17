import 'package:json_annotation/json_annotation.dart';

import '../enums/category_type.dart';

class CategoryTypeConverter implements JsonConverter<CategoryType, String> {
  const CategoryTypeConverter();

  @override
  CategoryType fromJson(String json) =>
      CategoryTypeExtension.fromValue(json);

  @override
  String toJson(CategoryType object) => object.value;
}
