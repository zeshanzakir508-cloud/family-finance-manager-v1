import 'package:json_annotation/json_annotation.dart';

import '../core/converters/category_type_converter.dart';
import '../core/enums/category_type.dart';
import 'base_model.dart';

part 'category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryModel extends BaseModel {
  @override
  final String id;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  @override
  final bool isDeleted;

  @override
  final DateTime? deletedAt;

  @override
  final int version;

  /// Family ID.
  final String familyId;

  /// Category name.
  final String name;

  /// Income or expense.
  @CategoryTypeConverter()
  final CategoryType type;

  /// Category color (ARGB integer).
  final int color;

  /// Material icon code point.
  final int iconCodePoint;

  /// Whether this is a built-in category.
  final bool isSystem;

  /// Display order.
  final int sortOrder;

  const CategoryModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.version = 1,
    required this.familyId,
    required this.name,
    required this.type,
    required this.color,
    required this.iconCodePoint,
    this.isSystem = false,
    this.sortOrder = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  CategoryModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    int? version,
    String? familyId,
    String? name,
    CategoryType? type,
    int? color,
    int? iconCodePoint,
    bool? isSystem,
    int? sortOrder,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      familyId: familyId ?? this.familyId,
      name: name ?? this.name,
      type: type ?? this.type,
      color: color ?? this.color,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      isSystem: isSystem ?? this.isSystem,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CategoryModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
