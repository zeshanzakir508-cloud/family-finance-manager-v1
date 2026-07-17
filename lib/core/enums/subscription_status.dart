/// Defines the user's subscription level.
///
/// Subscription expiry is determined separately using the
/// premiumExpiry field in UserModel.
enum SubscriptionStatus {
  /// Free plan.
  free,

  /// Paid subscription.
  premium,

  /// Lifetime premium granted by the developer.
  lifetime,
}

/// Convenience extensions for [SubscriptionStatus].
extension SubscriptionStatusExtension on SubscriptionStatus {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Returns true if the user is on the Free plan.
  bool get isFree => this == SubscriptionStatus.free;

  /// Returns true if the user has a paid Premium subscription.
  bool get isPremium => this == SubscriptionStatus.premium;

  /// Returns true if the user has Lifetime access.
  bool get isLifetime => this == SubscriptionStatus.lifetime;

  /// Returns true if premium features should be enabled.
  bool get hasPremiumAccess =>
      this == SubscriptionStatus.premium ||
      this == SubscriptionStatus.lifetime;

  /// Creates a [SubscriptionStatus] from a stored string value.
  static SubscriptionStatus fromValue(String value) {
    return SubscriptionStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => SubscriptionStatus.free,
    );
  }
}
