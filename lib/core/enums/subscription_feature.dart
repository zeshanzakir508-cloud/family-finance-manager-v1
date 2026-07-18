// lib/core/enums/subscription_feature.dart

/// Enum representing subscription features.
enum SubscriptionFeature {
  /// Premium features access.
  premium,

  /// Family sharing features.
  familySharing,

  /// Advanced analytics and reporting.
  analytics,

  /// Data export functionality.
  exportData,

  /// Backup and restore features.
  backup,

  /// Unlimited transactions.
  unlimitedTransactions,

  /// Multiple accounts support.
  multipleAccounts,

  /// Priority support.
  prioritySupport,
}

/// Extension methods for [SubscriptionFeature].
extension SubscriptionFeatureExtension on SubscriptionFeature {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [SubscriptionFeature] from a stored string value.
  static SubscriptionFeature fromValue(String value) {
    return SubscriptionFeature.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SubscriptionFeature.premium,
    );
  }
}
