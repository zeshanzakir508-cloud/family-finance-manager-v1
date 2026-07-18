// lib/data/repositories/subscription_repository_impl.dart

import '../../domain/repositories/subscription_repository.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_plan.dart';
import '../../domain/exceptions/subscription_exceptions.dart';
import '../datasources/remote/firestore_subscription_data_source.dart';
import '../models/subscription_model.dart';
import '../models/subscription_plan_model.dart';

/// Implementation of [SubscriptionRepository] that coordinates between domain and data layers.
///
/// This class delegates all data operations to the appropriate data sources
/// and converts between domain entities and data models.
///
/// This class MUST NOT contain any Firestore query logic, validation, UI code, or Riverpod code.
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final FirestoreSubscriptionDataSource _remoteDataSource;

  const SubscriptionRepositoryImpl({
    required FirestoreSubscriptionDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  /// Executes a repository operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on SubscriptionException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const SubscriptionDataException('Unexpected repository error.'),
        stackTrace,
      );
    }
  }

  /// Executes a stream repository operation with consistent error handling.
  Stream<T> _executeStream<T>(
    Stream<T> Function() action,
  ) async* {
    try {
      await for (final value in action()) {
        yield value;
      }
    } on SubscriptionException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const SubscriptionDataException('Unexpected repository stream error.'),
        stackTrace,
      );
    }
  }

  @override
  Future<Subscription> getSubscription(String subscriptionId) {
    return _execute(() async {
      final model = await _remoteDataSource.getSubscription(subscriptionId);
      return model.toDomain();
    });
  }

  @override
  Future<Subscription> getSubscriptionByUserId(String userId) {
    return _execute(() async {
      final model = await _remoteDataSource.getSubscriptionByUserId(userId);
      return model.toDomain();
    });
  }

  @override
  Future<List<Subscription>> getAllSubscriptions() {
    return _execute(() async {
      final models = await _remoteDataSource.getAllSubscriptions();
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Subscription>> getActiveSubscriptions() {
    return _execute(() async {
      final models = await _remoteDataSource.getActiveSubscriptions();
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Subscription>> getExpiredSubscriptions() {
    return _execute(() async {
      final models = await _remoteDataSource.getExpiredSubscriptions();
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Subscription>> getSubscriptionsByPlanId(String planId) {
    return _execute(() async {
      final models = await _remoteDataSource.getSubscriptionsByPlanId(planId);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<Subscription> createSubscription(Subscription subscription) {
    return _execute(() async {
      final model = SubscriptionModel.fromDomain(subscription);
      final createdModel = await _remoteDataSource.createSubscription(model);
      return createdModel.toDomain();
    });
  }

  @override
  Future<Subscription> updateSubscription(Subscription subscription) {
    return _execute(() async {
      final model = SubscriptionModel.fromDomain(subscription);
      final updatedModel = await _remoteDataSource.updateSubscription(model);
      return updatedModel.toDomain();
    });
  }

  @override
  Future<void> deleteSubscription(String subscriptionId) {
    return _execute(() async {
      await _remoteDataSource.deleteSubscription(subscriptionId);
    });
  }

  @override
  Future<Subscription> activateSubscription(String subscriptionId) {
    return _execute(() async {
      final model = await _remoteDataSource.activateSubscription(subscriptionId);
      return model.toDomain();
    });
  }

  @override
  Future<Subscription> deactivateSubscription(String subscriptionId) {
    return _execute(() async {
      final model = await _remoteDataSource.deactivateSubscription(subscriptionId);
      return model.toDomain();
    });
  }

  @override
  Future<Subscription> cancelSubscription(String subscriptionId) {
    return _execute(() async {
      final model = await _remoteDataSource.cancelSubscription(subscriptionId);
      return model.toDomain();
    });
  }

  @override
  Future<Subscription> renewSubscription(String subscriptionId) {
    return _execute(() async {
      final model = await _remoteDataSource.renewSubscription(subscriptionId);
      return model.toDomain();
    });
  }

  @override
  Future<Subscription> upgradeSubscription(String subscriptionId, String newPlanId) {
    return _execute(() async {
      final model = await _remoteDataSource.upgradeSubscription(subscriptionId, newPlanId);
      return model.toDomain();
    });
  }

  @override
  Future<Subscription> downgradeSubscription(String subscriptionId, String newPlanId) {
    return _execute(() async {
      final model = await _remoteDataSource.downgradeSubscription(subscriptionId, newPlanId);
      return model.toDomain();
    });
  }

  @override
  Future<bool> isSubscriptionActive(String userId) {
    return _execute(() async {
      return await _remoteDataSource.isSubscriptionActive(userId);
    });
  }

  @override
  Future<DateTime> getSubscriptionExpiryDate(String userId) {
    return _execute(() async {
      return await _remoteDataSource.getSubscriptionExpiryDate(userId);
    });
  }

  @override
  Future<int> getDaysRemaining(String userId) {
    return _execute(() async {
      return await _remoteDataSource.getDaysRemaining(userId);
    });
  }

  @override
  Future<SubscriptionPlan> getSubscriptionPlan(String planId) {
    return _execute(() async {
      final model = await _remoteDataSource.getSubscriptionPlan(planId);
      return model.toDomain();
    });
  }

  @override
  Future<List<SubscriptionPlan>> getAllSubscriptionPlans() {
    return _execute(() async {
      final models = await _remoteDataSource.getAllSubscriptionPlans();
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<SubscriptionPlan>> getActiveSubscriptionPlans() {
    return _execute(() async {
      final models = await _remoteDataSource.getActiveSubscriptionPlans();
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<SubscriptionPlan> createSubscriptionPlan(SubscriptionPlan plan) {
    return _execute(() async {
      final model = SubscriptionPlanModel.fromDomain(plan);
      final createdModel = await _remoteDataSource.createSubscriptionPlan(model);
      return createdModel.toDomain();
    });
  }

  @override
  Future<SubscriptionPlan> updateSubscriptionPlan(SubscriptionPlan plan) {
    return _execute(() async {
      final model = SubscriptionPlanModel.fromDomain(plan);
      final updatedModel = await _remoteDataSource.updateSubscriptionPlan(model);
      return updatedModel.toDomain();
    });
  }

  @override
  Future<void> deleteSubscriptionPlan(String planId) {
    return _execute(() async {
      await _remoteDataSource.deleteSubscriptionPlan(planId);
    });
  }

  @override
  Stream<Subscription> watchSubscription(String subscriptionId) {
    return _executeStream(
      () => _remoteDataSource.watchSubscription(subscriptionId).map(
            (model) => model.toDomain(),
          ),
    );
  }

  @override
  Stream<Subscription> watchSubscriptionByUserId(String userId) {
    return _executeStream(
      () => _remoteDataSource.watchSubscriptionByUserId(userId).map(
            (model) => model.toDomain(),
          ),
    );
  }

  @override
  Stream<List<Subscription>> watchActiveSubscriptions() {
    return _executeStream(
      () => _remoteDataSource.watchActiveSubscriptions().map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }

  @override
  Stream<SubscriptionPlan> watchSubscriptionPlan(String planId) {
    return _executeStream(
      () => _remoteDataSource.watchSubscriptionPlan(planId).map(
            (model) => model.toDomain(),
          ),
    );
  }

  @override
  Stream<List<SubscriptionPlan>> watchAllSubscriptionPlans() {
    return _executeStream(
      () => _remoteDataSource.watchAllSubscriptionPlans().map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }
}
