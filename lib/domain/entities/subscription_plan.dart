// lib/domain/entities/subscription_plan.dart

import 'package:equatable/equatable.dart';

import '../enums/subscription_tier.dart';
import '../enums/billing_interval.dart';
import '../enums/subscription_feature.dart';
import '../value_objects/plan_custom_features.dart';
import '../value_objects/subscription_plan_metadata.dart';
import '../value_objects/subscription_limits.dart';

/// Subscription plan entity representing a pricing plan.
///
/// This entity defines the pricing, features, and limits of a subscription plan.
/// Plans are used to determine what features users have access to.
class SubscriptionPlan extends Equatable {
  /// Unique identifier for the plan.
  /// Set by the persistence layer (Repository/DataSource).
  final String? id;

  /// Name of the plan.
  final String name;

  /// Description of the plan.
  final String? description;

  /// Price of the plan in the specified currency.
  final double price;

  /// Currency code (ISO 4217).
  final String currency;

  /// Billing interval (monthly, yearly, etc.).
  final BillingInterval billingInterval;

  /// Number of billing intervals per cycle.
  final int billingIntervalCount;

  /// Features included in this plan.
  final List<SubscriptionFeature> features;

  /// Tier of the plan (basic, premium, enterprise).
  final SubscriptionTier tier;

  /// Whether the plan is active and available for purchase.
  final bool isActive;

  /// Whether this is the most popular plan.
  final bool isPopular;

  /// Number of days for the trial period (0 = no trial).
  final int trialPeriodDays;

  /// Subscription limits for this plan.
  final SubscriptionLimits limits;

  /// Custom features specific to this plan.
  final PlanCustomFeatures customFeatures;

  /// Additional metadata.
  final SubscriptionPlanMetadata metadata;

  const SubscriptionPlan({
    this.id,
    required this.name,
    this.description,
    required this.price,
    this.currency = 'USD',
    this.billingInterval = BillingInterval.monthly,
    this.billingIntervalCount = 1,
    this.features = const [],
    this.tier = SubscriptionTier.basic,
    this.isActive = true,
    this.isPopular = false,
    this.trialPeriodDays = 0,
    this.limits = const SubscriptionLimits(),
    this.customFeatures = const PlanCustomFeatures(),
    this.metadata = const SubscriptionPlanMetadata(),
  })  : assert(price >= 0, 'Price cannot be negative'),
        assert(
          billingIntervalCount > 0,
          'Billing interval count must be greater than 0',
        ),
        assert(trialPeriodDays >= 0, 'Trial period days cannot be negative'),
        assert(name.isNotEmpty, 'Plan name cannot be empty');

  /// Creates a copy of this plan with the given fields replaced.
  SubscriptionPlan copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? currency,
    BillingInterval? billingInterval,
    int? billingIntervalCount,
    List<SubscriptionFeature>? features,
    SubscriptionTier? tier,
    bool? isActive,
    bool? isPopular,
    int? trialPeriodDays,
    SubscriptionLimits? limits,
    PlanCustomFeatures? customFeatures,
    SubscriptionPlanMetadata? metadata,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      billingInterval: billingInterval ?? this.billingInterval,
      billingIntervalCount: billingIntervalCount ?? this.billingIntervalCount,
      features: features ?? this.features,
      tier: tier ?? this.tier,
      isActive: isActive ?? this.isActive,
      isPopular: isPopular ?? this.isPopular,
      trialPeriodDays: trialPeriodDays ?? this.trialPeriodDays,
      limits: limits ?? this.limits,
      customFeatures: customFeatures ?? this.customFeatures,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Returns the formatted price with currency.
  String get formattedPrice => '$currency ${price.toStringAsFixed(2)}';

  /// Returns whether the plan has a trial period.
  bool get hasTrial => trialPeriodDays > 0;

  /// Returns whether this is a basic tier plan.
  bool get isBasicTier => tier == SubscriptionTier.basic;

  /// Returns whether this is a premium tier plan.
  bool get isPremiumTier => tier == SubscriptionTier.premium;

  /// Returns whether this is an enterprise tier plan.
  bool get isEnterpriseTier => tier == SubscriptionTier.enterprise;

  /// Returns whether the plan includes a specific feature.
  bool hasFeature(SubscriptionFeature feature) => features.contains(feature);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        currency,
        billingInterval,
        billingIntervalCount,
        features,
        tier,
        isActive,
        isPopular,
        trialPeriodDays,
        limits,
        customFeatures,
        metadata,
      ];
}
