import '../../../models/subscription_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Create Subscription Request
/// ----------------------------------------------------------------------------
/// Request object used when creating a subscription.
/// ============================================================================
class CreateSubscriptionRequest {
  /// Subscription information.
  final SubscriptionModel subscription;

  const CreateSubscriptionRequest({
    required this.subscription,
  });
}
