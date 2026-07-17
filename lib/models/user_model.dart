import 'package:json_annotation/json_annotation.dart';

import '../core/enums/account_status.dart';
import '../core/enums/app_role.dart';
import '../core/enums/subscription_status.dart';
import 'base_model.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel extends BaseModel {
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

  final String displayName;
  final String email;
  final bool emailVerified;
  final String? phoneNumber;
  final String? photoUrl;

  @JsonKey(
    fromJson: AppRoleExtension.fromValue,
    toJson: _appRoleToJson,
  )
  final AppRole appRole;

  @JsonKey(
    fromJson: AccountStatusExtension.fromValue,
    toJson: _accountStatusToJson,
  )
  final AccountStatus accountStatus;

  @JsonKey(
    fromJson: SubscriptionStatusExtension.fromValue,
    toJson: _subscriptionStatusToJson,
  )
  final SubscriptionStatus subscriptionStatus;

  final DateTime? premiumExpiry;

  final String languageCode;

  const UserModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.version = 1,
    required this.displayName,
    required this.email,
    this.emailVerified = false,
    this.phoneNumber,
    this.photoUrl,
    this.appRole = AppRole.user,
    this.accountStatus = AccountStatus.active,
    this.subscriptionStatus = SubscriptionStatus.free,
    this.premiumExpiry,
    this.languageCode = 'en',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    int? version,
    String? displayName,
    String? email,
    bool? emailVerified,
    String? phoneNumber,
    String? photoUrl,
    AppRole? appRole,
    AccountStatus? accountStatus,
    SubscriptionStatus? subscriptionStatus,
    DateTime? premiumExpiry,
    String? languageCode,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      appRole: appRole ?? this.appRole,
      accountStatus: accountStatus ?? this.accountStatus,
      subscriptionStatus:
          subscriptionStatus ?? this.subscriptionStatus,
      premiumExpiry: premiumExpiry ?? this.premiumExpiry,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, displayName: $displayName, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  static String _appRoleToJson(AppRole role) => role.value;

  static String _accountStatusToJson(AccountStatus status) => status.value;

  static String _subscriptionStatusToJson(
    SubscriptionStatus status,
  ) =>
      status.value;
}
