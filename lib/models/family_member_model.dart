import 'package:json_annotation/json_annotation.dart';

import '../core/converters/family_role_converter.dart';
import '../core/enums/family_role.dart';
import 'base_model.dart';

part 'family_member_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FamilyMemberModel extends BaseModel {
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

  /// User ID.
  final String userId;

  /// Member role within the family.
  @FamilyRoleConverter()
  final FamilyRole role;

  /// Indicates whether the member is currently active.
  final bool isActive;

  /// Date and time when the member joined the family.
  final DateTime joinedAt;

  const FamilyMemberModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.version = 1,
    required this.familyId,
    required this.userId,
    this.role = FamilyRole.member,
    this.isActive = true,
    required this.joinedAt,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FamilyMemberModelToJson(this);

  FamilyMemberModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    int? version,
    String? familyId,
    String? userId,
    FamilyRole? role,
    bool? isActive,
    DateTime? joinedAt,
  }) {
    return FamilyMemberModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      familyId: familyId ?? this.familyId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  String toString() {
    return 'FamilyMemberModel(id: $id, familyId: $familyId, userId: $userId, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FamilyMemberModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
