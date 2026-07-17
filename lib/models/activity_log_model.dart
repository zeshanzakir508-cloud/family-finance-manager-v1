import 'package:json_annotation/json_annotation.dart';

import '../core/converters/activity_type_converter.dart';
import '../core/converters/date_time_converter.dart';
import '../core/converters/nullable_date_time_converter.dart';
import '../core/enums/activity_type.dart';
import 'base_model.dart';

part 'activity_log_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ActivityLogModel extends BaseModel {
  @override
  final String id;

  @override
  @DateTimeConverter()
  final DateTime createdAt;

  @override
  @DateTimeConverter()
  final DateTime updatedAt;

  @override
  final bool isDeleted;

  @override
  @NullableDateTimeConverter()
  final DateTime? deletedAt;

  @override
  final int version;

  /// User who performed the action.
  final String userId;

  /// Optional family ID.
  final String? familyId;

  /// Activity type.
  @ActivityTypeConverter()
  final ActivityType type;

  /// Entity name (transaction, account, category, etc.).
  final String entity;

  /// Entity ID.
  final String entityId;

  /// Human-readable description.
  final String description;

  /// Additional structured data.
  final Map<String, dynamic> metadata;

  const ActivityLogModel({
    required this.id,
    @DateTimeConverter()
    required this.createdAt,
    @DateTimeConverter()
    required this.updatedAt,
    this.isDeleted = false,
    @NullableDateTimeConverter()
    this.deletedAt,
    this.version = 1,
    required this.userId,
    this.familyId,
    required this.type,
    required this.entity,
    required this.entityId,
    required this.description,
    this.metadata = const {},
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ActivityLogModelToJson(this);

  ActivityLogModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    int? version,
    String? userId,
    String? familyId,
    ActivityType? type,
    String? entity,
    String? entityId,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    return ActivityLogModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      userId: userId ?? this.userId,
      familyId: familyId ?? this.familyId,
      type: type ?? this.type,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'ActivityLogModel(id: $id, type: $type, entity: $entity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ActivityLogModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
