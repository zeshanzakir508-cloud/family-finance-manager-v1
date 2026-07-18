// lib/domain/value_objects/plan_custom_features.dart

import 'package:equatable/equatable.dart';

/// Value object representing custom features for a subscription plan.
class PlanCustomFeatures extends Equatable {
  /// Whether advanced analytics are included.
  final bool advancedAnalytics;

  /// Whether custom branding is included.
  final bool customBranding;

  /// Whether API access is included.
  final bool apiAccess;

  /// Whether white-label support is included.
  final bool whiteLabel;

  /// Whether dedicated support is included.
  final bool dedicatedSupport;

  const PlanCustomFeatures({
    this.advancedAnalytics = false,
    this.customBranding = false,
    this.apiAccess = false,
    this.whiteLabel = false,
    this.dedicatedSupport = false,
  });

  /// Creates a copy of these custom features with the given fields replaced.
  PlanCustomFeatures copyWith({
    bool? advancedAnalytics,
    bool? customBranding,
    bool? apiAccess,
    bool? whiteLabel,
    bool? dedicatedSupport,
  }) {
    return PlanCustomFeatures(
      advancedAnalytics: advancedAnalytics ?? this.advancedAnalytics,
      customBranding: customBranding ?? this.customBranding,
      apiAccess: apiAccess ?? this.apiAccess,
      whiteLabel: whiteLabel ?? this.whiteLabel,
      dedicatedSupport: dedicatedSupport ?? this.dedicatedSupport,
    );
  }

  /// Returns whether any custom features are enabled.
  bool get hasAnyFeatures =>
      advancedAnalytics ||
      customBranding ||
      apiAccess ||
      whiteLabel ||
      dedicatedSupport;

  /// Returns whether all custom features are enabled.
  bool get hasAllFeatures =>
      advancedAnalytics &&
      customBranding &&
      apiAccess &&
      whiteLabel &&
      dedicatedSupport;

  @override
  List<Object?> get props => [
        advancedAnalytics,
        customBranding,
        apiAccess,
        whiteLabel,
        dedicatedSupport,
      ];
}
