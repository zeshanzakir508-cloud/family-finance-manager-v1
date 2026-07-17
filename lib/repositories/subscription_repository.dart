import '../models/subscription_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Subscription Repository
/// ----------------------------------------------------------------------------
/// Defines the contract for managing user subscriptions.
///
/// Responsibilities:
/// • Create subscription
/// • Read subscription
/// • Update subscription
/// • Watch subscription changes
/// • Verify premium status
/// • Manage subscription lifecycle
///
/// NOTE:
/// This file only defines the repository contract.
/// Firebase implementation will be provided later.
/// ============================================================================

abstract class SubscriptionRepository {
  //==========================================================================
  // Subscription
  //==========================================================================

  /// Creates a new subscription.
  Future<void> createSubscription(
    SubscriptionModel subscription,
  );

  /// Returns a subscription by its ID.
  Future<SubscriptionModel?> getSubscription(
    String subscriptionId,
  );

  /// Returns the subscription for a user.
  Future<SubscriptionModel?> getUserSubscription(
    String userId,
  );

  /// Watches a subscription.
  Stream<SubscriptionModel?> watchSubscription(
    String subscriptionId,
  );

  /// Watches the subscription of a user.
  Stream<SubscriptionModel?> watchUserSubscription(
    String userId,
  );

  /// Updates an existing subscription.
  Future<void> updateSubscription(
    SubscriptionModel subscription,
  );

  /// Deletes a subscription.
  Future<void> deleteSubscription(
    String subscriptionId,
  );

  //==========================================================================
  // Status
  //==========================================================================

  /// Returns true if the user currently has premium access.
  Future<bool> isPremiumUser(
    String userId,
  );

  /// Returns true if the subscription has expired.
  Future<bool> isSubscriptionExpired(
    String userId,
  );

  /// Extends the subscription expiry date.
  Future<void> extendSubscription({
    required String userId,
    required DateTime expiryDate,
  });

  /// Cancels the user's subscription.
  Future<void> cancelSubscription(
    String userId,
  );

  /// Activates the user's subscription.
  Future<void> activateSubscription(
    String userId,
  );

  /// Downgrades the user to the free plan.
  Future<void> downgradeToFree(
    String userId,
  );

  //==========================================================================
  // Validation
  //==========================================================================

  /// Validates the current subscription.
  ///
  /// Intended for startup checks and premium feature access.
  Future<void> validateSubscription(
    String userId,
  );

  /// Refreshes subscription information from the data source.
  Future<SubscriptionModel?> refreshSubscription(
    String userId,
  );
}
