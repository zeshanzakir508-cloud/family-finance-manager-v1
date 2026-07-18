import '../../../models/subscription_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Update Subscription Request
/// ----------------------------------------------------------------------------
/// Request object used when updating a subscription.
/// ============================================================================
class UpdateSubscriptionRequest {
  /// Updated subscription.
  final SubscriptionModel subscription;

  const UpdateSubscriptionRequest({
    required this.subscription,
  });
}
