import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/enums/subscription_status.dart';
import '../models/subscription_model.dart';

final premiumProvider =
    StateNotifierProvider<PremiumNotifier, AsyncValue<SubscriptionModel?>>(
  (ref) => PremiumNotifier(),
);

class PremiumNotifier
    extends StateNotifier<AsyncValue<SubscriptionModel?>> {
  PremiumNotifier() : super(const AsyncValue.loading());

  Future<void> loadSubscription(String userId) async {
    state = const AsyncValue.loading();

    // TODO:
    // Load subscription from Firestore repository.
  }

  Future<void> refresh() async {
    // TODO:
    // Reload subscription.
  }

  Future<void> clear() async {
    state = const AsyncValue.data(null);
  }

  bool get hasPremium {
    final subscription = state.value;

    if (subscription == null) {
      return false;
    }

    switch (subscription.status) {
      case SubscriptionStatus.lifetime:
        return true;

      case SubscriptionStatus.premium:
        final expiry = subscription.expiryDate;

        if (expiry == null) {
          return false;
        }

        return expiry.isAfter(DateTime.now());

      case SubscriptionStatus.free:
        return false;
    }
  }
}
