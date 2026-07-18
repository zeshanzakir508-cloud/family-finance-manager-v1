// lib/domain/value_objects/subscription_plan_extra_metadata.dart

import 'package:equatable/equatable.dart';

import '../enums/plan_highlight_color.dart';
import 'subscription_plan_extra_custom_metadata.dart';

/// Value object representing additional subscription plan metadata.
class SubscriptionPlanExtraMetadata extends Equatable {
  /// Whether the plan is recommended.
  final bool isRecommended;

  /// Highlight color for the plan card.
  final PlanHighlightColor? highlightColor;

  /// Featured tag for the plan.
  final String? featuredTag;

  /// Additional custom metadata.
  final SubscriptionPlanExtraCustomMetadata? customData;

  const SubscriptionPlanExtraMetadata({
    this.isRecommended = false,
    this.highlightColor,
    this.featuredTag,
    this.customData,
  });

  /// Creates a copy of this extra metadata with the given fields replaced.
  SubscriptionPlanExtraMetadata copyWith({
    bool? isRecommended,
    PlanHighlightColor? highlightColor,
    String? featuredTag,
    SubscriptionPlanExtraCustomMetadata? customData,
  }) {
    return SubscriptionPlanExtraMetadata(
      isRecommended: isRecommended ?? this.isRecommended,
      highlightColor: highlightColor ?? this.highlightColor,
      featuredTag: featuredTag ?? this.featuredTag,
      customData: customData ?? this.customData,
    );
  }

  /// Returns true if any extra metadata is present.
  bool get hasContent =>
      isRecommended ||
      highlightColor != null ||
      featuredTag != null ||
      (customData != null && customData!.hasContent);

  @override
  List<Object?> get props => [
        isRecommended,
        highlightColor,
        featuredTag,
        customData,
      ];
}
