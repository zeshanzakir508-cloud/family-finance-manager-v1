// lib/domain/value_objects/subscription_plan_metadata.dart

import 'package:equatable/equatable.dart';

import 'subscription_plan_extra_metadata.dart';

/// Value object representing subscription plan metadata.
class SubscriptionPlanMetadata extends Equatable {
  /// Display order in the pricing page.
  final int displayOrder;

  /// Badge text to show on the plan card.
  final String? badgeText;

  /// URL to the plan's icon.
  final String? iconUrl;

  /// Tagline for the plan.
  final String? tagline;

  /// Additional custom metadata.
  final SubscriptionPlanExtraMetadata? extra;

  const SubscriptionPlanMetadata({
    this.displayOrder = 0,
    this.badgeText,
    this.iconUrl,
    this.tagline,
    this.extra,
  }) : assert(displayOrder >= 0, 'Display order cannot be negative');

  /// Creates a copy of this metadata with the given fields replaced.
  SubscriptionPlanMetadata copyWith({
    int? displayOrder,
    String? badgeText,
    String? iconUrl,
    String? tagline,
    SubscriptionPlanExtraMetadata? extra,
  }) {
    return SubscriptionPlanMetadata(
      displayOrder: displayOrder ?? this.displayOrder,
      badgeText: badgeText ?? this.badgeText,
      iconUrl: iconUrl ?? this.iconUrl,
      tagline: tagline ?? this.tagline,
      extra: extra ?? this.extra,
    );
  }

  /// Returns true if any metadata is present.
  bool get hasContent =>
      badgeText != null ||
      iconUrl != null ||
      tagline != null ||
      (extra != null && extra!.hasContent);

  @override
  List<Object?> get props => [
        displayOrder,
        badgeText,
        iconUrl,
        tagline,
        extra,
      ];
}
