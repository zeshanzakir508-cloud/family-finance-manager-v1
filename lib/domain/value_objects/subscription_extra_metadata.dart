// lib/domain/value_objects/subscription_extra_metadata.dart

import 'package:equatable/equatable.dart';

import '../enums/subscription_platform.dart';
import 'subscription_extra_custom_metadata.dart';

/// Value object representing additional subscription metadata.
class SubscriptionExtraMetadata extends Equatable {
  /// Campaign ID associated with the subscription.
  final String? campaignId;

  /// UTM source for tracking.
  final String? utmSource;

  /// UTM medium for tracking.
  final String? utmMedium;

  /// UTM campaign for tracking.
  final String? utmCampaign;

  /// Platform where the subscription was purchased.
  final SubscriptionPlatform? platform;

  /// Additional custom metadata.
  final SubscriptionExtraCustomMetadata? customData;

  const SubscriptionExtraMetadata({
    this.campaignId,
    this.utmSource,
    this.utmMedium,
    this.utmCampaign,
    this.platform,
    this.customData,
  });

  /// Creates a copy of this extra metadata with the given fields replaced.
  SubscriptionExtraMetadata copyWith({
    String? campaignId,
    String? utmSource,
    String? utmMedium,
    String? utmCampaign,
    SubscriptionPlatform? platform,
    SubscriptionExtraCustomMetadata? customData,
  }) {
    return SubscriptionExtraMetadata(
      campaignId: campaignId ?? this.campaignId,
      utmSource: utmSource ?? this.utmSource,
      utmMedium: utmMedium ?? this.utmMedium,
      utmCampaign: utmCampaign ?? this.utmCampaign,
      platform: platform ?? this.platform,
      customData: customData ?? this.customData,
    );
  }

  /// Returns true if any extra metadata is present.
  bool get hasContent =>
      campaignId != null ||
      utmSource != null ||
      utmMedium != null ||
      utmCampaign != null ||
      platform != null ||
      (customData != null && customData!.hasContent);

  @override
  List<Object?> get props => [
        campaignId,
        utmSource,
        utmMedium,
        utmCampaign,
        platform,
        customData,
      ];
}
