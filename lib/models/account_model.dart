import 'package:json_annotation/json_annotation.dart';

import '../core/converters/account_type_converter.dart';
import '../core/converters/date_time_converter.dart';
import '../core/converters/nullable_date_time_converter.dart';
import '../core/enums/account_type.dart';
import 'base_model.dart';

part 'account_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AccountModel extends BaseModel {
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

  /// Family ID.
  final String familyId;

  /// Account owner (User ID).
  final String ownerId;

  /// Account name.
  final String name;

  /// Account type.
  @AccountTypeConverter()
  final AccountType type;

  /// Current account balance.
  final double balance;

  /// Currency code (ISO 4217).
  final String currencyCode;

  /// Whether the account is active.
  final bool isActive;

  const AccountModel({
    required this.id,
    @DateTimeConverter()
    required this.createdAt,
    @DateTimeConverter()
    required this.updatedAt,
    this.isDeleted = false,
    @NullableDateTimeConverter()
    this.deletedAt,
    this.version = 1,
    required this.familyId,
    required this.ownerId,
    required this.name,
    required this.type,
    this.balance = 0,
    this.currencyCode = 'PKR',
    this.isActive = true,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AccountModelToJson(this);

  AccountModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    int? version,
    String? familyId,
    String? ownerId,
    String? name,
    AccountType? type,
    double? balance,
    String? currencyCode,
    bool? isActive,
  }) {
    return AccountModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      familyId: familyId ?? this.familyId,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currencyCode: currencyCode ?? this.currencyCode,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'AccountModel(id: $id, name: $name, type: $type, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AccountModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
