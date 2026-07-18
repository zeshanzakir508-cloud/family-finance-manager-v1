// lib/core/enums/subscription_tier.dart

/// Enum representing subscription plan tiers.
enum SubscriptionTier {
  /// Basic tier - entry level features.
  basic,

  /// Premium tier - advanced features.
  premium,

  /// Enterprise tier - full features with higher limits.
  enterprise,
}

/// Extension methods for [SubscriptionTier].
extension SubscriptionTierExtension on SubscriptionTier {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [SubscriptionTier] from a stored string value.
  static SubscriptionTier fromValue(String value) {
    return SubscriptionTier.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SubscriptionTier.basic,
    );
  }

  /// Returns whether this is a basic tier.
  bool get isBasic => this == SubscriptionTier.basic;

  /// Returns whether this is a premium tier.
  bool get isPremium => this == SubscriptionTier.premium;

  /// Returns whether this is an enterprise tier.
  bool get isEnterprise => this == SubscriptionTier.enterprise;

  /// Returns whether this is a higher tier than the given tier.
  bool isHigherThan(SubscriptionTier other) => index > other.index;

  /// Returns whether this is a lower tier than the given tier.
  bool isLowerThan(SubscriptionTier other) => index < other.index;
}
