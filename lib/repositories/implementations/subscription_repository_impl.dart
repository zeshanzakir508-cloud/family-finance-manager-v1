// lib/repositories/implementations/subscription_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../interfaces/subscription_repository.dart';
import '../interfaces/base_repository.dart';
import '../../services/firestore_service.dart';
import '../../constants/firestore_constants.dart';
import '../../models/subscription_model.dart';
import '../../exceptions/app_exception.dart';
import '../../exceptions/firestore_exception.dart';

/// Implementation of SubscriptionRepository that handles all subscription-related Firestore operations.
///
/// This repository follows the single responsibility principle and only handles
/// data persistence. All business logic should be in domain managers/use cases.
///
/// Subscriptions track recurring payments for services, memberships, and other
/// periodic expenses. They include billing cycles, payment methods, renewal dates,
/// and cancellation tracking.
class SubscriptionRepositoryImpl extends BaseRepository implements SubscriptionRepository {
  SubscriptionRepositoryImpl({
    required FirestoreService firestoreService,
  }) : super(firestoreService);

  @override
  String get collectionPath => FirestoreConstants.subscriptions;

  // ==================== Private Helpers ====================

  /// Updates a subset of subscription fields while maintaining version consistency
  /// using a transaction for atomicity.
  ///
  /// Why: Using a transaction ensures the version is read and incremented atomically,
  /// preventing race conditions when multiple clients update the same subscription.
  Future<void> _updateFieldsWithTransaction(
    String subscriptionId,
    Map<String, dynamic> fields,
  ) async {
    try {
      final docRef = getDocumentReference(subscriptionId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Subscription not found: $subscriptionId');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        final updateData = {
          ...fields,
          FirestoreConstants.updatedAt: now,
          FirestoreConstants.version: currentVersion + 1,
        };
        
        transaction.update(docRef, updateData);
      });
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update subscription fields for $subscriptionId: ${e.toString()}');
    }
  }

  /// Performs a full subscription update using a transaction for atomicity.
  ///
  /// Why: Like partial updates, full updates should be atomic to prevent
  /// race conditions with concurrent modifications.
  Future<void> _updateFullSubscription(
    SubscriptionModel subscription,
  ) async {
    try {
      final docRef = getDocumentReference(subscription.id);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Subscription not found: ${subscription.id}');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        final updatedSubscription = subscription.copyWith(
          updatedAt: now,
          version: currentVersion + 1,
        );
        
        transaction.update(docRef, updatedSubscription.toJson());
      });
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update subscription ${subscription.id}: ${e.toString()}');
    }
  }

  /// Performs a soft delete using a transaction for atomicity.
  ///
  /// Why: Soft deletes should be atomic to prevent race conditions with
  /// concurrent updates or multiple delete attempts.
  Future<void> _softDeleteWithTransaction(
    String subscriptionId,
  ) async {
    try {
      final docRef = getDocumentReference(subscriptionId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Subscription not found: $subscriptionId');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        final updateData = {
          FirestoreConstants.isDeleted: true,
          FirestoreConstants.deletedAt: now,
          FirestoreConstants.updatedAt: now,
          FirestoreConstants.version: currentVersion + 1,
          FirestoreConstants.status: SubscriptionStatus.cancelled.value,
        };
        
        transaction.update(docRef, updateData);
      });
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to delete subscription $subscriptionId: ${e.toString()}');
    }
  }

  /// Performs a restore using a transaction for atomicity.
  ///
  /// Why: Restores should be atomic to prevent race conditions with
  /// concurrent updates or multiple restore attempts.
  Future<void> _restoreWithTransaction(
    String subscriptionId,
  ) async {
    try {
      final docRef = getDocumentReference(subscriptionId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Subscription not found: $subscriptionId');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        final updateData = {
          FirestoreConstants.isDeleted: false,
          FirestoreConstants.deletedAt: null,
          FirestoreConstants.updatedAt: now,
          FirestoreConstants.version: currentVersion + 1,
          FirestoreConstants.status: SubscriptionStatus.active.value,
        };
        
        transaction.update(docRef, updateData);
      });
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to restore subscription $subscriptionId: ${e.toString()}');
    }
  }

  /// Builds a query with common subscription filters.
  Query _buildSubscriptionQuery({
    required String familyId,
    String? categoryId,
    String? status,
    String? billingCycle,
    DateTime? startDate,
    DateTime? endDate,
    bool includeDeleted = false,
  }) {
    final collection = firestoreService.collection(collectionPath);
    Query query = collection
        .where(FirestoreConstants.familyId, isEqualTo: familyId);

    if (!includeDeleted) {
      query = query.where(FirestoreConstants.isDeleted, isEqualTo: false);
    }

    if (categoryId != null) {
      query = query.where(FirestoreConstants.categoryId, isEqualTo: categoryId);
    }

    if (status != null) {
      query = query.where(FirestoreConstants.status, isEqualTo: status);
    }

    if (billingCycle != null) {
      query = query.where(FirestoreConstants.billingCycle, isEqualTo: billingCycle);
    }

    if (startDate != null) {
      query = query.where(
        FirestoreConstants.startDate,
        isGreaterThanOrEqualTo: startDate,
      );
    }

    if (endDate != null) {
      query = query.where(
        FirestoreConstants.endDate,
        isLessThanOrEqualTo: endDate,
      );
    }

    return query;
  }

  // ==================== Public Methods ====================

  @override
  Future<void> createSubscription(SubscriptionModel subscription) async {
    try {
      final now = DateTime.now();
      
      final newSubscription = subscription.copyWith(
        version: 1,
        createdAt: now,
        updatedAt: now,
        status: SubscriptionStatus.active.value,
      );
      
      await setDocument(
        subscription.id,
        newSubscription.toJson(),
      );
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to create subscription ${subscription.id}: ${e.toString()}');
    }
  }

  @override
  Future<SubscriptionModel?> getSubscription(String subscriptionId) async {
    try {
      final doc = await getDocument(subscriptionId);
      if (!doc.exists) return null;
      return SubscriptionModel.fromJson(doc.data()!);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get subscription $subscriptionId: ${e.toString()}');
    }
  }

  @override
  Stream<SubscriptionModel?> watchSubscription(String subscriptionId) {
    return watchDocument(subscriptionId).map((doc) {
      if (!doc.exists) return null;
      return SubscriptionModel.fromJson(doc.data()!);
    });
  }

  @override
  Future<void> updateSubscription(SubscriptionModel subscription) async {
    try {
      await _updateFullSubscription(subscription);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update subscription ${subscription.id}: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteSubscription(String subscriptionId) async {
    try {
      await _softDeleteWithTransaction(subscriptionId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to delete subscription $subscriptionId: ${e.toString()}');
    }
  }

  @override
  Future<void> restoreSubscription(String subscriptionId) async {
    try {
      await _restoreWithTransaction(subscriptionId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to restore subscription $subscriptionId: ${e.toString()}');
    }
  }

  @override
  Future<bool> subscriptionExists(String subscriptionId) async {
    try {
      return await documentExists(subscriptionId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to check subscription existence for $subscriptionId: ${e.toString()}');
    }
  }

  // ==================== Query Methods ====================

  @override
  Future<List<SubscriptionModel>> getSubscriptionsByFamily({
    required String familyId,
    bool includeDeleted = false,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildSubscriptionQuery(
        familyId: familyId,
        includeDeleted: includeDeleted,
      );

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final docs = await query
          .orderBy(FirestoreConstants.startDate, descending: true)
          .limit(limit)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => SubscriptionModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get subscriptions for family $familyId: ${e.toString()}');
    }
  }

  @override
  Future<List<SubscriptionModel>> getActiveSubscriptions({
    required String familyId,
    bool includeDeleted = false,
  }) async {
    try {
      final query = _buildSubscriptionQuery(
        familyId: familyId,
        status: SubscriptionStatus.active.value,
        includeDeleted: includeDeleted,
      );

      final docs = await query
          .orderBy(FirestoreConstants.startDate, descending: true)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => SubscriptionModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get active subscriptions for family $familyId: ${e.toString()}');
    }
  }

  @override
  Future<List<SubscriptionModel>> getSubscriptionsByCategory({
    required String categoryId,
    required String familyId,
    bool includeDeleted = false,
  }) async {
    try {
      final query = _buildSubscriptionQuery(
        familyId: familyId,
        categoryId: categoryId,
        includeDeleted: includeDeleted,
      );

      final docs = await query
          .orderBy(FirestoreConstants.startDate, descending: true)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => SubscriptionModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get subscriptions for category $categoryId: ${e.toString()}');
    }
  }

  @override
  Future<List<SubscriptionModel>> getSubscriptionsByStatus({
    required String familyId,
    required String status,
    bool includeDeleted = false,
  }) async {
    try {
      final query = _buildSubscriptionQuery(
        familyId: familyId,
        status: status,
        includeDeleted: includeDeleted,
      );

      final docs = await query
          .orderBy(FirestoreConstants.startDate, descending: true)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => SubscriptionModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get subscriptions by status $status: ${e.toString()}');
    }
  }

  @override
  Future<List<SubscriptionModel>> getUpcomingRenewals({
    required String familyId,
    required DateTime startDate,
    required DateTime endDate,
    bool includeDeleted = false,
  }) async {
    try {
      final query = _buildSubscriptionQuery(
        familyId: familyId,
        status: SubscriptionStatus.active.value,
        includeDeleted: includeDeleted,
      );

      final docs = await query
          .where(
            FirestoreConstants.nextRenewalDate,
            isGreaterThanOrEqualTo: startDate,
          )
          .where(
            FirestoreConstants.nextRenewalDate,
            isLessThanOrEqualTo: endDate,
          )
          .orderBy(FirestoreConstants.nextRenewalDate, descending: false)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => SubscriptionModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get upcoming renewals: ${e.toString()}');
    }
  }

  @override
  Future<List<SubscriptionModel>> getExpiringSoon({
    required String familyId,
    required int daysThreshold,
    bool includeDeleted = false,
  }) async {
    try {
      final now = DateTime.now();
      final thresholdDate = now.add(Duration(days: daysThreshold));

      final query = _buildSubscriptionQuery(
        familyId: familyId,
        status: SubscriptionStatus.active.value,
        includeDeleted: includeDeleted,
      );

      final docs = await query
          .where(
            FirestoreConstants.endDate,
            isLessThanOrEqualTo: thresholdDate,
          )
          .where(
            FirestoreConstants.endDate,
            isGreaterThanOrEqualTo: now,
          )
          .orderBy(FirestoreConstants.endDate, descending: false)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => SubscriptionModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get expiring subscriptions: ${e.toString()}');
    }
  }

  @override
  Stream<List<SubscriptionModel>> watchSubscriptionsByFamily({
    required String familyId,
    bool includeDeleted = false,
  }) {
    try {
      final query = _buildSubscriptionQuery(
        familyId: familyId,
        includeDeleted: includeDeleted,
      ).orderBy(FirestoreConstants.startDate, descending: true);

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .where((doc) => doc.exists)
            .map((doc) => SubscriptionModel.fromJson(doc.data()))
            .toList();
      });
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to watch subscriptions for family $familyId: ${e.toString()}');
    }
  }

  // ==================== Subscription Management Methods ====================

  @override
  Future<void> cancelSubscription(String subscriptionId) async {
    await _updateFieldsWithTransaction(
      subscriptionId,
      {
        FirestoreConstants.status: SubscriptionStatus.cancelled.value,
        FirestoreConstants.cancelledAt: DateTime.now(),
      },
    );
  }

  @override
  Future<void> reactivateSubscription(String subscriptionId) async {
    await _updateFieldsWithTransaction(
      subscriptionId,
      {
        FirestoreConstants.status: SubscriptionStatus.active.value,
        FirestoreConstants.cancelledAt: null,
      },
    );
  }

  @override
  Future<void> pauseSubscription(String subscriptionId) async {
    await _updateFieldsWithTransaction(
      subscriptionId,
      {
        FirestoreConstants.status: SubscriptionStatus.paused.value,
        FirestoreConstants.pausedAt: DateTime.now(),
      },
    );
  }

  @override
  Future<void> resumeSubscription(String subscriptionId) async {
    await _updateFieldsWithTransaction(
      subscriptionId,
      {
        FirestoreConstants.status: SubscriptionStatus.active.value,
        FirestoreConstants.pausedAt: null,
      },
    );
  }

  @override
  Future<void> updateRenewalDate({
    required String subscriptionId,
    required DateTime newRenewalDate,
  }) async {
    await _updateFieldsWithTransaction(
      subscriptionId,
      {FirestoreConstants.nextRenewalDate: newRenewalDate},
    );
  }

  @override
  Future<void> updateSubscriptionAmount({
    required String subscriptionId,
    required double newAmount,
  }) async {
    await _updateFieldsWithTransaction(
      subscriptionId,
      {FirestoreConstants.amount: newAmount},
    );
  }

  @override
  Future<void> updateBillingCycle({
    required String subscriptionId,
    required String newBillingCycle,
  }) async {
    await _updateFieldsWithTransaction(
      subscriptionId,
      {FirestoreConstants.billingCycle: newBillingCycle},
    );
  }

  @override
  Future<void> updatePaymentMethod({
    required String subscriptionId,
    required String newPaymentMethod,
  }) async {
    await _updateFieldsWithTransaction(
      subscriptionId,
      {FirestoreConstants.paymentMethod: newPaymentMethod},
    );
  }

  @override
  Future<void> markPaymentFailed(String subscriptionId) async {
    final now = DateTime.now();
    await _updateFieldsWithTransaction(
      subscriptionId,
      {
        FirestoreConstants.status: SubscriptionStatus.overdue.value,
        FirestoreConstants.lastPaymentFailedAt: now,
      },
    );
  }

  @override
  Future<void> markPaymentSucceeded(String subscriptionId) async {
    await _updateFieldsWithTransaction(
      subscriptionId,
      {
        FirestoreConstants.status: SubscriptionStatus.active.value,
        FirestoreConstants.lastPaymentFailedAt: null,
      },
    );
  }

  @override
  Future<void> updateSubscriptionStatus({
    required String subscriptionId,
    required String status,
  }) async {
    await _updateFieldsWithTransaction(
      subscriptionId,
      {FirestoreConstants.status: status},
    );
  }
}
