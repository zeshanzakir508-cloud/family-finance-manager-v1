import 'package:json_annotation/json_annotation.dart';

import '../core/converters/date_time_converter.dart';
import '../core/converters/notification_type_converter.dart';
import '../core/converters/nullable_date_time_converter.dart';
import '../core/enums/notification_type.dart';
import 'base_model.dart';

part 'notification_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationModel extends BaseModel {
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

  /// Recipient user ID.
  final String userId;

  /// Optional family ID.
  final String? familyId;

  /// Notification type.
  @NotificationTypeConverter()
  final NotificationType type;

  /// Notification title.
  final String title;

  /// Notification body.
  final String message;

  /// Optional navigation route.
  final String? route;

  /// Optional document ID.
  final String? referenceId;

  /// Read status.
  final bool isRead;

  /// Read timestamp.
  @NullableDateTimeConverter()
  final DateTime? readAt;

  const NotificationModel({
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
    this.type = NotificationType.system,
    required this.title,
    required this.message,
    this.route,
    this.referenceId,
    this.isRead = false,
    @NullableDateTimeConverter()
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    int? version,
    String? userId,
    String? familyId,
    NotificationType? type,
    String? title,
    String? message,
    String? route,
    String? referenceId,
    bool? isRead,
    DateTime? readAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      userId: userId ?? this.userId,
      familyId: familyId ?? this.familyId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      route: route ?? this.route,
      referenceId: referenceId ?? this.referenceId,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
    );
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NotificationModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
