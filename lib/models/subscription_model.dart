import 'package:json_annotation/json_annotation.dart';

import '../core/enums/subscription_status.dart';
import '../core/converters/subscription_status_converter.dart';
import 'base_model.dart';

part 'subscription_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SubscriptionModel extends BaseModel {
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

  /// User ID.
  final String userId;

  @SubscriptionStatusConverter()
  final SubscriptionStatus status;

  /// Purchase date.
  final DateTime purchaseDate;

  /// Expiry date.
  ///
  /// Null for lifetime subscriptions.
  final DateTime? expiryDate;

  /// Google Play purchase token.
  final String? purchaseToken;

  /// Google Play product ID.
  final String? productId;

  /// Indicates whether auto-renew is enabled.
  final bool autoRenewing;

  /// Last verification with the billing server.
  final DateTime? lastVerifiedAt;

  const SubscriptionModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.version = 1,
    required this.userId,
    required this.status,
    required this.purchaseDate,
    this.expiryDate,
    this.purchaseToken,
    this.productId,
    this.autoRenewing = false,
    this.lastVerifiedAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);

  SubscriptionModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    int? version,
    String? userId,
    SubscriptionStatus? status,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? purchaseToken,
    String? productId,
    bool? autoRenewing,
    DateTime? lastVerifiedAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      purchaseToken: purchaseToken ?? this.purchaseToken,
      productId: productId ?? this.productId,
      autoRenewing: autoRenewing ?? this.autoRenewing,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
    );
  }

  @override
  String toString() {
    return 'SubscriptionModel(id: $id, userId: $userId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SubscriptionModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
