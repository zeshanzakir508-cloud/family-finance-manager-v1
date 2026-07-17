import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'family_post_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FamilyPostModel extends BaseModel {
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

  /// User ID of the author.
  final String createdBy;

  /// Post content.
  final String content;

  /// Attached image URLs.
  final List<String> imageUrls;

  /// Total likes.
  final int likeCount;

  /// Total comments.
  final int commentCount;

  /// Whether comments are allowed.
  final bool commentsEnabled;

  const FamilyPostModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.version = 1,
    required this.familyId,
    required this.createdBy,
    required this.content,
    this.imageUrls = const [],
    this.likeCount = 0,
    this.commentCount = 0,
    this.commentsEnabled = true,
  });

  factory FamilyPostModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyPostModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FamilyPostModelToJson(this);

  FamilyPostModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    int? version,
    String? familyId,
    String? createdBy,
    String? content,
    List<String>? imageUrls,
    int? likeCount,
    int? commentCount,
    bool? commentsEnabled,
  }) {
    return FamilyPostModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      familyId: familyId ?? this.familyId,
      createdBy: createdBy ?? this.createdBy,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      commentsEnabled: commentsEnabled ?? this.commentsEnabled,
    );
  }

  @override
  String toString() {
    return 'FamilyPostModel(id: $id, familyId: $familyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FamilyPostModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
