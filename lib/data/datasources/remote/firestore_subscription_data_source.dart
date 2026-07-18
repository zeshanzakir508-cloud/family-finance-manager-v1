// lib/data/datasources/remote/firestore_subscription_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/exceptions/subscription_exceptions.dart';
import '../../models/subscription_model.dart';
import '../../models/subscription_plan_model.dart';

/// Data source for Firestore Subscription operations.
///
/// This class handles all direct communication with Firestore for subscription-related
/// operations and converts Firestore results to models. It is the only layer that
/// should contain Firestore query logic for subscriptions and subscription plans.
///
/// This class MUST NOT contain any business logic, validation, UI code, or Riverpod code.
class FirestoreSubscriptionDataSource {
  final FirebaseFirestore _firestore;

  FirestoreSubscriptionDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  /// Collection reference for subscriptions.
  CollectionReference<Map<String, dynamic>> get _subscriptionsCollection =>
      _firestore.collection('subscriptions');

  /// Collection reference for subscription plans.
  CollectionReference<Map<String, dynamic>> get _plansCollection =>
      _firestore.collection('subscriptionPlans');

  /// Document reference for a specific subscription.
  DocumentReference<Map<String, dynamic>> _subscriptionDocument(String subscriptionId) =>
      _subscriptionsCollection.doc(subscriptionId);

  /// Document reference for a specific subscription plan.
  DocumentReference<Map<String, dynamic>> _planDocument(String planId) =>
      _plansCollection.doc(planId);

  /// Executes a Firestore operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(_handleFirestoreException(e), stackTrace);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const SubscriptionDataException('Unexpected subscription data source error.'),
        stackTrace,
      );
    }
  }

  /// Executes a stream Firestore operation with consistent error handling.
  Stream<T> _executeStream<T>(
    Stream<T> Function() action,
  ) async* {
    try {
      await for (final value in action()) {
        yield value;
      }
    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(_handleFirestoreException(e), stackTrace);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const SubscriptionDataException('Unexpected subscription stream error.'),
        stackTrace,
      );
    }
  }

  /// Converts FirestoreException to domain SubscriptionException.
  SubscriptionException _handleFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const SubscriptionDataException('Permission denied to access subscription data.');
      case 'not-found':
        return const SubscriptionNotFoundException('Subscription not found.');
      case 'already-exists':
        return const SubscriptionDataException('Subscription already exists.');
      case 'failed-precondition':
        return const SubscriptionDataException('Precondition failed for subscription operation.');
      case 'aborted':
        return const SubscriptionDataException('Subscription operation was aborted.');
      case 'out-of-range':
        return const SubscriptionDataException('Subscription operation out of range.');
      case 'unimplemented':
        return const SubscriptionDataException('Subscription operation not implemented.');
      case 'internal':
        return const SubscriptionDataException('Internal error accessing subscription data.');
      case 'unavailable':
        return const SubscriptionDataException('Subscription service is temporarily unavailable.');
      case 'deadline-exceeded':
        return const SubscriptionDataException('Subscription operation timed out.');
      default:
        return SubscriptionDataException('Subscription error: ${e.message ?? 'Unknown error'}');
    }
  }

  // ==================== Mapping Methods ====================

  /// Converts Firestore DocumentSnapshot to SubscriptionModel.
  SubscriptionModel _documentToSubscriptionModel(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const SubscriptionDataException('Subscription document data is null.');
    }

    final startDate = (data['startDate'] as Timestamp?)?.toDate();
    if (startDate == null) {
      throw const SubscriptionDataException('Subscription start date is required.');
    }

    final endDate = (data['endDate'] as Timestamp?)?.toDate();

    return SubscriptionModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      planId: data['planId'] as String? ?? '',
      status: data['status'] as String? ?? 'inactive',
      startDate: startDate,
      endDate: endDate,
      autoRenew: data['autoRenew'] as bool? ?? false,
      paymentMethod: data['paymentMethod'] as String?,
      paymentProvider: data['paymentProvider'] as String?,
      providerSubscriptionId: data['providerSubscriptionId'] as String?,
      trialEndDate: (data['trialEndDate'] as Timestamp?)?.toDate(),
      cancelledAt: (data['cancelledAt'] as Timestamp?)?.toDate(),
      cancelledReason: data['cancelledReason'] as String?,
      lastPaymentDate: (data['lastPaymentDate'] as Timestamp?)?.toDate(),
      nextPaymentDate: (data['nextPaymentDate'] as Timestamp?)?.toDate(),
      features: (data['features'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      metadata: (data['metadata'] as Map<String, dynamic>?) ?? {},
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts Firestore DocumentSnapshot to SubscriptionPlanModel.
  SubscriptionPlanModel _documentToPlanModel(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const SubscriptionDataException('Subscription plan document data is null.');
    }

    return SubscriptionPlanModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String?,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      currency: data['currency'] as String? ?? 'USD',
      billingInterval: data['billingInterval'] as String? ?? 'monthly',
      billingIntervalCount: data['billingIntervalCount'] as int? ?? 1,
      features: (data['features'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      tier: data['tier'] as String? ?? 'basic',
      isActive: data['isActive'] as bool? ?? true,
      isPopular: data['isPopular'] as bool? ?? false,
      trialPeriodDays: data['trialPeriodDays'] as int? ?? 0,
      maxUsers: data['maxUsers'] as int? ?? 1,
      maxAccounts: data['maxAccounts'] as int? ?? 5,
      maxCategories: data['maxCategories'] as int? ?? 20,
      maxTransactions: data['maxTransactions'] as int? ?? 1000,
      customFeatures: (data['customFeatures'] as Map<String, dynamic>?) ?? {},
      metadata: (data['metadata'] as Map<String, dynamic>?) ?? {},
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts SubscriptionModel to Firestore map for creation.
  Map<String, dynamic> _subscriptionToCreateMap(SubscriptionModel model) {
    return {
      'userId': model.userId,
      'planId': model.planId,
      'status': model.status,
      'startDate': model.startDate,
      'endDate': model.endDate,
      'autoRenew': model.autoRenew,
      'paymentMethod': model.paymentMethod,
      'paymentProvider': model.paymentProvider,
      'providerSubscriptionId': model.providerSubscriptionId,
      'trialEndDate': model.trialEndDate,
      'cancelledAt': model.cancelledAt,
      'cancelledReason': model.cancelledReason,
      'lastPaymentDate': model.lastPaymentDate,
      'nextPaymentDate': model.nextPaymentDate,
      'features': model.features,
      'metadata': model.metadata,
    };
  }

  /// Converts SubscriptionModel to Firestore map for updates.
  Map<String, dynamic> _subscriptionToUpdateMap(SubscriptionModel model) {
    final map = <String, dynamic>{
      'planId': model.planId,
      'status': model.status,
      'startDate': model.startDate,
      'autoRenew': model.autoRenew,
      'endDate': model.endDate,
      'lastPaymentDate': model.lastPaymentDate,
      'nextPaymentDate': model.nextPaymentDate,
      'features': model.features,
      'metadata': model.metadata,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Only include optional fields if they have values
    if (model.paymentMethod != null) map['paymentMethod'] = model.paymentMethod;
    if (model.paymentProvider != null) map['paymentProvider'] = model.paymentProvider;
    if (model.providerSubscriptionId != null) {
      map['providerSubscriptionId'] = model.providerSubscriptionId;
    }
    if (model.trialEndDate != null) map['trialEndDate'] = model.trialEndDate;
    if (model.cancelledAt != null) map['cancelledAt'] = model.cancelledAt;
    if (model.cancelledReason != null) map['cancelledReason'] = model.cancelledReason;

    return map;
  }

  /// Creates a map for creating a subscription with server timestamps.
  Map<String, dynamic> _createSubscriptionWithTimestamps(SubscriptionModel model) {
    return {
      ..._subscriptionToCreateMap(model),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Converts SubscriptionPlanModel to Firestore map for creation.
  Map<String, dynamic> _planToCreateMap(SubscriptionPlanModel model) {
    return {
      'name': model.name,
      'description': model.description,
      'price': model.price,
      'currency': model.currency,
      'billingInterval': model.billingInterval,
      'billingIntervalCount': model.billingIntervalCount,
      'features': model.features,
      'tier': model.tier,
      'isActive': model.isActive,
      'isPopular': model.isPopular,
      'trialPeriodDays': model.trialPeriodDays,
      'maxUsers': model.maxUsers,
      'maxAccounts': model.maxAccounts,
      'maxCategories': model.maxCategories,
      'maxTransactions': model.maxTransactions,
      'customFeatures': model.customFeatures,
      'metadata': model.metadata,
    };
  }

  /// Converts SubscriptionPlanModel to Firestore map for updates.
  Map<String, dynamic> _planToUpdateMap(SubscriptionPlanModel model) {
    final map = <String, dynamic>{
      'name': model.name,
      'price': model.price,
      'currency': model.currency,
      'billingInterval': model.billingInterval,
      'billingIntervalCount': model.billingIntervalCount,
      'features': model.features,
      'tier': model.tier,
      'isActive': model.isActive,
      'isPopular': model.isPopular,
      'trialPeriodDays': model.trialPeriodDays,
      'maxUsers': model.maxUsers,
      'maxAccounts': model.maxAccounts,
      'maxCategories': model.maxCategories,
      'maxTransactions': model.maxTransactions,
      'customFeatures': model.customFeatures,
      'metadata': model.metadata,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Only include optional fields if they have values
    if (model.description != null) map['description'] = model.description;

    return map;
  }

  /// Creates a map for creating a subscription plan with server timestamps.
  Map<String, dynamic> _createPlanWithTimestamps(SubscriptionPlanModel model) {
    return {
      ..._planToCreateMap(model),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Internal helper to update subscription fields and return the updated model.
  Future<SubscriptionModel> _updateSubscriptionFields(
    String subscriptionId,
    Map<String, dynamic> updateData,
  ) async {
    final docRef = _subscriptionDocument(subscriptionId);
    final doc = await docRef.get();

    if (!doc.exists) {
      throw const SubscriptionNotFoundException('Subscription not found.');
    }

    updateData['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.update(updateData);

    final updatedDoc = await docRef.get();
    return _documentToSubscriptionModel(updatedDoc);
  }

  /// Internal helper to update plan fields and return the updated model.
  Future<SubscriptionPlanModel> _updatePlanFields(
    String planId,
    Map<String, dynamic> updateData,
  ) async {
    final docRef = _planDocument(planId);
    final doc = await docRef.get();

    if (!doc.exists) {
      throw const SubscriptionDataException('Subscription plan not found.');
    }

    updateData['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.update(updateData);

    final updatedDoc = await docRef.get();
    return _documentToPlanModel(updatedDoc);
  }

  // ==================== Subscription Read Operations ====================

  /// Gets a subscription by ID.
  Future<SubscriptionModel> getSubscription(String subscriptionId) {
    return _execute(() async {
      final doc = await _subscriptionDocument(subscriptionId).get();
      if (!doc.exists) {
        throw const SubscriptionNotFoundException('Subscription not found.');
      }
      return _documentToSubscriptionModel(doc);
    });
  }

  /// Gets a subscription by user ID.
  Future<SubscriptionModel> getSubscriptionByUserId(String userId) {
    return _execute(() async {
      final query = await _subscriptionsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw const SubscriptionNotFoundException('Subscription not found for user.');
      }

      return _documentToSubscriptionModel(query.docs.first);
    });
  }

  /// Gets all subscriptions.
  Future<List<SubscriptionModel>> getAllSubscriptions() {
    return _execute(() async {
      final query = await _subscriptionsCollection
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToSubscriptionModel).toList();
    });
  }

  /// Gets active subscriptions.
  Future<List<SubscriptionModel>> getActiveSubscriptions() {
    return _execute(() async {
      final query = await _subscriptionsCollection
          .where('status', isEqualTo: 'active')
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToSubscriptionModel).toList();
    });
  }

  /// Gets expired subscriptions.
  Future<List<SubscriptionModel>> getExpiredSubscriptions() {
    return _execute(() async {
      final query = await _subscriptionsCollection
          .where('status', isEqualTo: 'expired')
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToSubscriptionModel).toList();
    });
  }

  /// Gets subscriptions by plan ID.
  Future<List<SubscriptionModel>> getSubscriptionsByPlanId(String planId) {
    return _execute(() async {
      final query = await _subscriptionsCollection
          .where('planId', isEqualTo: planId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToSubscriptionModel).toList();
    });
  }

  /// Gets subscriptions by status.
  Future<List<SubscriptionModel>> getSubscriptionsByStatus(String status) {
    return _execute(() async {
      final query = await _subscriptionsCollection
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToSubscriptionModel).toList();
    });
  }

  /// Gets subscriptions expiring soon.
  Future<List<SubscriptionModel>> getSubscriptionsExpiringSoon(DateTime threshold) {
    return _execute(() async {
      final query = await _subscriptionsCollection
          .where('endDate', isLessThanOrEqualTo: threshold)
          .where('status', isEqualTo: 'active')
          .orderBy('endDate', ascending: true)
          .get();

      return query.docs.map(_documentToSubscriptionModel).toList();
    });
  }

  // ==================== Subscription Write Operations ====================

  /// Creates a new subscription.
  Future<SubscriptionModel> createSubscription(SubscriptionModel subscription) {
    return _execute(() async {
      final docRef = _subscriptionsCollection.doc();
      final newSubscription = subscription.copyWith(
        id: docRef.id,
      );

      await docRef.set(_createSubscriptionWithTimestamps(newSubscription));

      final doc = await docRef.get();
      return _documentToSubscriptionModel(doc);
    });
  }

  /// Updates an existing subscription.
  Future<SubscriptionModel> updateSubscription(SubscriptionModel subscription) {
    return _execute(() async {
      return await _updateSubscriptionFields(
        subscription.id,
        _subscriptionToUpdateMap(subscription),
      );
    });
  }

  /// Deletes a subscription.
  Future<void> deleteSubscription(String subscriptionId) {
    return _execute(() async {
      final docRef = _subscriptionDocument(subscriptionId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const SubscriptionNotFoundException('Subscription not found.');
      }

      await docRef.delete();
    });
  }

  /// Activates a subscription.
  Future<SubscriptionModel> activateSubscription(String subscriptionId) {
    return _execute(() async {
      return await _updateSubscriptionFields(
        subscriptionId,
        {
          'status': 'active',
        },
      );
    });
  }

  /// Deactivates a subscription.
  Future<SubscriptionModel> deactivateSubscription(String subscriptionId) {
    return _execute(() async {
      return await _updateSubscriptionFields(
        subscriptionId,
        {
          'status': 'inactive',
        },
      );
    });
  }

  /// Cancels a subscription.
  Future<SubscriptionModel> cancelSubscription(String subscriptionId) {
    return _execute(() async {
      return await _updateSubscriptionFields(
        subscriptionId,
        {
          'status': 'cancelled',
          'cancelledAt': FieldValue.serverTimestamp(),
        },
      );
    });
  }

  /// Renews a subscription with a new end date.
  Future<SubscriptionModel> renewSubscription(
    String subscriptionId,
    DateTime newEndDate,
  ) {
    return _execute(() async {
      return await _updateSubscriptionFields(
        subscriptionId,
        {
          'status': 'active',
          'endDate': newEndDate,
          'lastPaymentDate': FieldValue.serverTimestamp(),
          'nextPaymentDate': newEndDate,
        },
      );
    });
  }

  /// Upgrades a subscription to a new plan.
  Future<SubscriptionModel> upgradeSubscription(String subscriptionId, String newPlanId) {
    return _execute(() async {
      // Verify the new plan exists
      final planDoc = await _planDocument(newPlanId).get();
      if (!planDoc.exists) {
        throw const SubscriptionDataException('Plan not found.');
      }

      return await _updateSubscriptionFields(
        subscriptionId,
        {
          'planId': newPlanId,
          'status': 'active',
        },
      );
    });
  }

  /// Downgrades a subscription to a new plan.
  Future<SubscriptionModel> downgradeSubscription(String subscriptionId, String newPlanId) {
    return _execute(() async {
      // Verify the new plan exists
      final planDoc = await _planDocument(newPlanId).get();
      if (!planDoc.exists) {
        throw const SubscriptionDataException('Plan not found.');
      }

      return await _updateSubscriptionFields(
        subscriptionId,
        {
          'planId': newPlanId,
        },
      );
    });
  }

  /// Updates subscription status.
  Future<SubscriptionModel> updateSubscriptionStatus(String subscriptionId, String status) {
    return _execute(() async {
      return await _updateSubscriptionFields(
        subscriptionId,
        {
          'status': status,
        },
      );
    });
  }

  /// Updates payment information.
  Future<SubscriptionModel> updatePaymentInfo(
    String subscriptionId,
    String paymentMethod,
    String? providerSubscriptionId,
  ) {
    return _execute(() async {
      final updateData = <String, dynamic>{
        'paymentMethod': paymentMethod,
      };

      if (providerSubscriptionId != null) {
        updateData['providerSubscriptionId'] = providerSubscriptionId;
      }

      return await _updateSubscriptionFields(subscriptionId, updateData);
    });
  }

  /// Updates auto-renew setting.
  Future<SubscriptionModel> updateAutoRenew(
    String subscriptionId,
    bool autoRenew,
  ) {
    return _execute(() async {
      return await _updateSubscriptionFields(
        subscriptionId,
        {
          'autoRenew': autoRenew,
        },
      );
    });
  }

  // ==================== Subscription Status Queries ====================

  /// Checks if a subscription is active.
  Future<bool> isSubscriptionActive(String userId) {
    return _execute(() async {
      final query = await _subscriptionsCollection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    });
  }

  /// Gets subscription expiry date.
  Future<DateTime?> getSubscriptionExpiryDate(String userId) {
    return _execute(() async {
      final query = await _subscriptionsCollection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .orderBy('endDate', descending: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return null;
      }

      final data = query.docs.first.data();
      return (data['endDate'] as Timestamp?)?.toDate();
    });
  }

  // ==================== Subscription Plan Operations ====================

  /// Gets a subscription plan by ID.
  Future<SubscriptionPlanModel> getSubscriptionPlan(String planId) {
    return _execute(() async {
      final doc = await _planDocument(planId).get();
      if (!doc.exists) {
        throw const SubscriptionDataException('Subscription plan not found.');
      }
      return _documentToPlanModel(doc);
    });
  }

  /// Gets all subscription plans.
  Future<List<SubscriptionPlanModel>> getAllSubscriptionPlans() {
    return _execute(() async {
      final query = await _plansCollection
          .where('isActive', isEqualTo: true)
          .orderBy('price', ascending: true)
          .get();

      return query.docs.map(_documentToPlanModel).toList();
    });
  }

  /// Gets active subscription plans.
  Future<List<SubscriptionPlanModel>> getActiveSubscriptionPlans() {
    return _execute(() async {
      final query = await _plansCollection
          .where('isActive', isEqualTo: true)
          .orderBy('price', ascending: true)
          .get();

      return query.docs.map(_documentToPlanModel).toList();
    });
  }

  /// Gets subscription plans by tier.
  Future<List<SubscriptionPlanModel>> getPlansByTier(String tier) {
    return _execute(() async {
      final query = await _plansCollection
          .where('tier', isEqualTo: tier)
          .where('isActive', isEqualTo: true)
          .orderBy('price', ascending: true)
          .get();

      return query.docs.map(_documentToPlanModel).toList();
    });
  }

  /// Creates a subscription plan.
  Future<SubscriptionPlanModel> createSubscriptionPlan(SubscriptionPlanModel plan) {
    return _execute(() async {
      final docRef = _plansCollection.doc();
      final newPlan = plan.copyWith(
        id: docRef.id,
      );

      await docRef.set(_createPlanWithTimestamps(newPlan));

      final doc = await docRef.get();
      return _documentToPlanModel(doc);
    });
  }

  /// Updates a subscription plan.
  Future<SubscriptionPlanModel> updateSubscriptionPlan(SubscriptionPlanModel plan) {
    return _execute(() async {
      return await _updatePlanFields(
        plan.id,
        _planToUpdateMap(plan),
      );
    });
  }

  /// Deletes a subscription plan.
  Future<void> deleteSubscriptionPlan(String planId) {
    return _execute(() async {
      final docRef = _planDocument(planId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const SubscriptionDataException('Subscription plan not found.');
      }

      await docRef.delete();
    });
  }

  /// Activates a subscription plan.
  Future<SubscriptionPlanModel> activatePlan(String planId) {
    return _execute(() async {
      return await _updatePlanFields(
        planId,
        {'isActive': true},
      );
    });
  }

  /// Deactivates a subscription plan.
  Future<SubscriptionPlanModel> deactivatePlan(String planId) {
    return _execute(() async {
      return await _updatePlanFields(
        planId,
        {'isActive': false},
      );
    });
  }

  /// Sets a plan as popular.
  Future<SubscriptionPlanModel> setPlanPopular(String planId, bool isPopular) {
    return _execute(() async {
      // If setting as popular, clear all other popular flags
      if (isPopular) {
        final query = await _plansCollection
            .where('isPopular', isEqualTo: true)
            .get();

        final batch = _firestore.batch();
        for (final doc in query.docs) {
          batch.update(doc.reference, {'isPopular': false});
        }
        await batch.commit();
      }

      return await _updatePlanFields(
        planId,
        {'isPopular': isPopular},
      );
    });
  }

  // ==================== Stream Operations ====================

  /// Watches a subscription in real-time.
  Stream<SubscriptionModel> watchSubscription(String subscriptionId) {
    return _executeStream(
      () => _subscriptionDocument(subscriptionId).snapshots().map((doc) {
        if (!doc.exists) {
          throw const SubscriptionNotFoundException('Subscription not found.');
        }
        return _documentToSubscriptionModel(doc);
      }),
    );
  }

  /// Watches a subscription by user ID in real-time.
  Stream<SubscriptionModel> watchSubscriptionByUserId(String userId) {
    return _executeStream(
      () => _subscriptionsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .snapshots()
          .map((query) {
            if (query.docs.isEmpty) {
              throw const SubscriptionNotFoundException('Subscription not found for user.');
            }
            return _documentToSubscriptionModel(query.docs.first);
          }),
    );
  }

  /// Watches active subscriptions in real-time.
  Stream<List<SubscriptionModel>> watchActiveSubscriptions() {
    return _executeStream(
      () => _subscriptionsCollection
          .where('status', isEqualTo: 'active')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToSubscriptionModel).toList()),
    );
  }

  /// Watches subscriptions by status in real-time.
  Stream<List<SubscriptionModel>> watchSubscriptionsByStatus(String status) {
    return _executeStream(
      () => _subscriptionsCollection
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToSubscriptionModel).toList()),
    );
  }

  /// Watches a subscription plan in real-time.
  Stream<SubscriptionPlanModel> watchSubscriptionPlan(String planId) {
    return _executeStream(
      () => _planDocument(planId).snapshots().map((doc) {
        if (!doc.exists) {
          throw const SubscriptionDataException('Subscription plan not found.');
        }
        return _documentToPlanModel(doc);
      }),
    );
  }

  /// Watches all subscription plans in real-time.
  Stream<List<SubscriptionPlanModel>> watchAllSubscriptionPlans() {
    return _executeStream(
      () => _plansCollection
          .where('isActive', isEqualTo: true)
          .orderBy('price', ascending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToPlanModel).toList()),
    );
  }

  /// Watches subscription plans by tier in real-time.
  Stream<List<SubscriptionPlanModel>> watchPlansByTier(String tier) {
    return _executeStream(
      () => _plansCollection
          .where('tier', isEqualTo: tier)
          .where('isActive', isEqualTo: true)
          .orderBy('price', ascending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToPlanModel).toList()),
    );
  }
}
