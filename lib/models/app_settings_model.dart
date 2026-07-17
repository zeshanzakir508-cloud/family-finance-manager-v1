import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'app_settings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppSettingsModel extends BaseModel {
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

  /// Default currency (ISO 4217).
  final String currencyCode;

  /// Default language.
  final String languageCode;

  /// Theme mode.
  ///
  /// Values:
  /// - system
  /// - light
  /// - dark
  final String themeMode;

  /// First day of week.
  ///
  /// 1 = Monday
  /// 7 = Sunday
  final int firstDayOfWeek;

  /// Whether notifications are enabled.
  final bool notificationsEnabled;

  /// Whether transaction reminders are enabled.
  final bool reminderEnabled;

  /// Daily reminder hour (0-23).
  final int reminderHour;

  /// Daily reminder minute (0-59).
  final int reminderMinute;

  const AppSettingsModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.version = 1,
    required this.familyId,
    this.currencyCode = 'PKR',
    this.languageCode = 'en',
    this.themeMode = 'system',
    this.firstDayOfWeek = 1,
    this.notificationsEnabled = true,
    this.reminderEnabled = false,
    this.reminderHour = 20,
    this.reminderMinute = 0,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppSettingsModelToJson(this);

  AppSettingsModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    int? version,
    String? familyId,
    String? currencyCode,
    String? languageCode,
    String? themeMode,
    int? firstDayOfWeek,
    bool? notificationsEnabled,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return AppSettingsModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      familyId: familyId ?? this.familyId,
      currencyCode: currencyCode ?? this.currencyCode,
      languageCode: languageCode ?? this.languageCode,
      themeMode: themeMode ?? this.themeMode,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }

  @override
  String toString() {
    return 'AppSettingsModel(id: $id, familyId: $familyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppSettingsModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
