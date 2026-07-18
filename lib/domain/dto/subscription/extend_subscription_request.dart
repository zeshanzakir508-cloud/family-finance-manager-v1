/// ============================================================================
/// Family Finance Manager
/// Extend Subscription Request
/// ============================================================================
class ExtendSubscriptionRequest {
  final String userId;
  final DateTime expiryDate;

  const ExtendSubscriptionRequest({
    required this.userId,
    required this.expiryDate,
  });
}
