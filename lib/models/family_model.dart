import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'family_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FamilyModel extends BaseModel {
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

  /// Family name.
  final String name;

  /// Optional family description.
  final String? description;

  /// Family creator (User ID).
  final String ownerId;

  /// Optional family profile image.
  final String? photoUrl;

  const FamilyModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.version = 1,
    required this.name,
    this.description,
    required this.ownerId,
    this.photoUrl,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FamilyModelToJson(this);

  FamilyModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    int? version,
    String? name,
    String? description,
    String? ownerId,
    String? photoUrl,
  }) {
    return FamilyModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      name: name ?? this.name,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  String toString() {
    return 'FamilyModel(id: $id, name: $name, ownerId: $ownerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FamilyModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
