// lib/domain/value_objects/subscription_metadata.dart

import 'package:equatable/equatable.dart';

import 'subscription_extra_metadata.dart';

/// Value object representing subscription metadata.
class SubscriptionMetadata extends Equatable {
  /// IP address used for the purchase.
  final String? ipAddress;

  /// User agent used for the purchase.
  final String? userAgent;

  /// Coupon code applied (if any).
  final String? couponCode;

  /// Referral source (if any).
  final String? referralSource;

  /// Additional custom metadata.
  final SubscriptionExtraMetadata? extra;

  const SubscriptionMetadata({
    this.ipAddress,
    this.userAgent,
    this.couponCode,
    this.referralSource,
    this.extra,
  });

  /// Creates a copy of this subscription metadata with the given fields replaced.
  SubscriptionMetadata copyWith({
    String? ipAddress,
    String? userAgent,
    String? couponCode,
    String? referralSource,
    SubscriptionExtraMetadata? extra,
  }) {
    return SubscriptionMetadata(
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      couponCode: couponCode ?? this.couponCode,
      referralSource: referralSource ?? this.referralSource,
      extra: extra ?? this.extra,
    );
  }

  /// Returns true if any metadata is present.
  bool get hasContent =>
      ipAddress != null ||
      userAgent != null ||
      couponCode != null ||
      referralSource != null ||
      (extra != null && extra!.hasContent);

  @override
  List<Object?> get props => [
        ipAddress,
        userAgent,
        couponCode,
        referralSource,
        extra,
      ];
}
