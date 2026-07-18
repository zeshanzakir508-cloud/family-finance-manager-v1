// lib/repositories/implementations/notification_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../interfaces/notification_repository.dart';
import '../interfaces/base_repository.dart';
import '../../services/firestore_service.dart';
import '../../constants/firestore_constants.dart';
import '../../models/notification_model.dart';
import '../../exceptions/app_exception.dart';
import '../../exceptions/firestore_exception.dart';

/// Implementation of NotificationRepository that handles all notification-related Firestore operations.
///
/// This repository follows the single responsibility principle and only handles
/// data persistence. All business logic should be in domain managers/use cases.
///
/// Notifications can be of different types (transaction, budget, family, system, etc.)
/// and can be targeted to specific users or broadcast to all family members.
/// The repository provides methods to create, read, update, and delete notifications,
/// as well as mark them as read or dismissed.
class NotificationRepositoryImpl extends BaseRepository implements NotificationRepository {
  NotificationRepositoryImpl({
    required FirestoreService firestoreService,
  }) : super(firestoreService);

  @override
  String get collectionPath => FirestoreConstants.notifications;

  // ==================== Private Helpers ====================

  /// Updates a subset of notification fields while maintaining version consistency.
  Future<void> _updateFields(
    String notificationId,
    Map<String, dynamic> fields,
  ) async {
    try {
      final notification = await getNotification(notificationId);
      if (notification == null) {
        throw AppException('Notification not found: $notificationId');
      }

      final now = DateTime.now();
      final updateData = {
        ...fields,
        FirestoreConstants.updatedAt: now,
        FirestoreConstants.version: notification.version + 1,
      };

      await updateDocument(notificationId, updateData);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update notification fields for $notificationId: ${e.toString()}');
    }
  }

  /// Builds a query with common notification filters.
  Query _buildNotificationQuery({
    required String userId,
    String? familyId,
    String? type,
    bool? isRead,
    bool? isDismissed,
    DateTime? startDate,
    DateTime? endDate,
    bool includeDeleted = false,
  }) {
    final collection = firestoreService.collection(collectionPath);
    Query query = collection
        .where(FirestoreConstants.userId, isEqualTo: userId);

    if (!includeDeleted) {
      query = query.where(FirestoreConstants.isDeleted, isEqualTo: false);
    }

    if (familyId != null) {
      query = query.where(FirestoreConstants.familyId, isEqualTo: familyId);
    }

    if (type != null) {
      query = query.where(FirestoreConstants.type, isEqualTo: type);
    }

    if (isRead != null) {
      query = query.where(FirestoreConstants.isRead, isEqualTo: isRead);
    }

    if (isDismissed != null) {
      query = query.where(FirestoreConstants.isDismissed, isEqualTo: isDismissed);
    }

    if (startDate != null) {
      query = query.where(
        FirestoreConstants.createdAt,
        isGreaterThanOrEqualTo: startDate,
      );
    }

    if (endDate != null) {
      query = query.where(
        FirestoreConstants.createdAt,
        isLessThanOrEqualTo: endDate,
      );
    }

    return query;
  }

  /// Performs a batch update with version increment using a transaction.
  ///
  /// Why: This ensures versions are incremented atomically, preventing
  /// race conditions when multiple clients modify notifications simultaneously.
  Future<void> _batchUpdateWithVersionIncrement(
    Map<String, Map<String, dynamic>> updates,
  ) async {
    try {
      await runTransaction((transaction) async {
        final updateData = <String, Map<String, dynamic>>{};

        // Read all documents first to get current versions
        for (final entry in updates.entries) {
          final docRef = getDocumentReference(entry.key);
          final doc = await transaction.get(docRef);
          if (!doc.exists) {
            throw AppException('Notification not found: ${entry.key}');
          }

          final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
          final now = DateTime.now();
          
          final data = {
            ...entry.value,
            FirestoreConstants.updatedAt: now,
            FirestoreConstants.version: currentVersion + 1,
          };
          
          updateData[entry.key] = data;
        }

        // Apply all updates within the same transaction
        for (final entry in updateData.entries) {
          final docRef = getDocumentReference(entry.key);
          transaction.update(docRef, entry.value);
        }
      });
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to batch update notifications: ${e.toString()}');
    }
  }

  // ==================== Public Methods ====================

  @override
  Future<void> createNotification(NotificationModel notification) async {
    try {
      final now = DateTime.now();
      
      final newNotification = notification.copyWith(
        version: 1,
        createdAt: now,
        updatedAt: now,
        isRead: false,
        isDismissed: false,
      );
      
      await setDocument(
        notification.id,
        newNotification.toJson(),
      );
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to create notification ${notification.id}: ${e.toString()}');
    }
  }

  @override
  Future<NotificationModel?> getNotification(String notificationId) async {
    try {
      final doc = await getDocument(notificationId);
      if (!doc.exists) return null;
      return NotificationModel.fromJson(doc.data()!);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get notification $notificationId: ${e.toString()}');
    }
  }

  @override
  Stream<NotificationModel?> watchNotification(String notificationId) {
    return watchDocument(notificationId).map((doc) {
      if (!doc.exists) return null;
      return NotificationModel.fromJson(doc.data()!);
    });
  }

  @override
  Future<void> updateNotification(NotificationModel notification) async {
    try {
      final existing = await getNotification(notification.id);
      if (existing == null) {
        throw AppException('Notification not found: ${notification.id}');
      }

      final now = DateTime.now();
      final updatedNotification = notification.copyWith(
        updatedAt: now,
        version: existing.version + 1,
      );
      
      await updateDocument(notification.id, updatedNotification.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update notification ${notification.id}: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      final notification = await getNotification(notificationId);
      if (notification == null) {
        throw AppException('Notification not found: $notificationId');
      }

      final now = DateTime.now();
      final updatedNotification = notification.copyWith(
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
        version: notification.version + 1,
      );
      
      await updateDocument(notificationId, updatedNotification.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to delete notification $notificationId: ${e.toString()}');
    }
  }

  @override
  Future<void> restoreNotification(String notificationId) async {
    try {
      final notification = await getNotification(notificationId);
      if (notification == null) {
        throw AppException('Notification not found: $notificationId');
      }

      final now = DateTime.now();
      final updatedNotification = notification.copyWith(
        isDeleted: false,
        deletedAt: null,
        updatedAt: now,
        version: notification.version + 1,
      );
      
      await updateDocument(notificationId, updatedNotification.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to restore notification $notificationId: ${e.toString()}');
    }
  }

  @override
  Future<bool> notificationExists(String notificationId) async {
    try {
      return await documentExists(notificationId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to check notification existence for $notificationId: ${e.toString()}');
    }
  }

  // ==================== Query Methods ====================

  @override
  Future<List<NotificationModel>> getNotificationsByUser({
    required String userId,
    bool unreadOnly = false,
    bool includeDeleted = false,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildNotificationQuery(
        userId: userId,
        includeDeleted: includeDeleted,
        isRead: unreadOnly ? false : null,
      );

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final docs = await query
          .orderBy(FirestoreConstants.createdAt, descending: true)
          .limit(limit)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get notifications for user $userId: ${e.toString()}');
    }
  }

  @override
  Future<List<NotificationModel>> getNotificationsByFamily({
    required String familyId,
    required String userId,
    bool unreadOnly = false,
    bool includeDeleted = false,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildNotificationQuery(
        userId: userId,
        familyId: familyId,
        includeDeleted: includeDeleted,
        isRead: unreadOnly ? false : null,
      );

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final docs = await query
          .orderBy(FirestoreConstants.createdAt, descending: true)
          .limit(limit)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get notifications for family $familyId: ${e.toString()}');
    }
  }

  @override
  Future<List<NotificationModel>> getNotificationsByType({
    required String userId,
    required String type,
    bool includeDeleted = false,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildNotificationQuery(
        userId: userId,
        type: type,
        includeDeleted: includeDeleted,
      );

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final docs = await query
          .orderBy(FirestoreConstants.createdAt, descending: true)
          .limit(limit)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get notifications by type $type: ${e.toString()}');
    }
  }

  @override
  Future<List<NotificationModel>> getUnreadNotifications({
    required String userId,
    bool includeDeleted = false,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    return getNotificationsByUser(
      userId: userId,
      unreadOnly: true,
      includeDeleted: includeDeleted,
      limit: limit,
      startAfter: startAfter,
    );
  }

  @override
  Future<int> getUnreadCount({
    required String userId,
    String? familyId,
  }) async {
    try {
      var query = _buildNotificationQuery(
        userId: userId,
        familyId: familyId,
        isRead: false,
        isDismissed: false,
        includeDeleted: false,
      );

      final snapshot = await query.count().get();
      return snapshot.count;
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get unread count for user $userId: ${e.toString()}');
    }
  }

  @override
  Stream<List<NotificationModel>> watchNotificationsByUser({
    required String userId,
    bool unreadOnly = false,
    bool includeDeleted = false,
  }) {
    try {
      final query = _buildNotificationQuery(
        userId: userId,
        includeDeleted: includeDeleted,
        isRead: unreadOnly ? false : null,
      ).orderBy(FirestoreConstants.createdAt, descending: true);

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .where((doc) => doc.exists)
            .map((doc) => NotificationModel.fromJson(doc.data()))
            .toList();
      });
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to watch notifications for user $userId: ${e.toString()}');
    }
  }

  // ==================== Notification Management Methods ====================

  @override
  Future<void> markAsRead(String notificationId) async {
    await _updateFields(
      notificationId,
      {
        FirestoreConstants.isRead: true,
        FirestoreConstants.readAt: DateTime.now(),
      },
    );
  }

  @override
  Future<void> markAsUnread(String notificationId) async {
    await _updateFields(
      notificationId,
      {
        FirestoreConstants.isRead: false,
        FirestoreConstants.readAt: null,
      },
    );
  }

  @override
  Future<void> dismissNotification(String notificationId) async {
    await _updateFields(
      notificationId,
      {
        FirestoreConstants.isDismissed: true,
        FirestoreConstants.dismissedAt: DateTime.now(),
      },
    );
  }

  @override
  Future<void> markAllAsRead({
    required String userId,
    String? familyId,
  }) async {
    try {
      // Use the family-aware query
      final notifications = familyId != null
          ? await getNotificationsByFamily(
              familyId: familyId,
              userId: userId,
              unreadOnly: true,
              includeDeleted: false,
            )
          : await getNotificationsByUser(
              userId: userId,
              unreadOnly: true,
              includeDeleted: false,
            );

      if (notifications.isEmpty) return;

      final updates = <String, Map<String, dynamic>>{};
      final now = DateTime.now();

      for (final notification in notifications) {
        if (!notification.isRead) {
          updates[notification.id] = {
            FirestoreConstants.isRead: true,
            FirestoreConstants.readAt: now,
          };
        }
      }

      // Use transaction for atomic updates with version checking
      await _batchUpdateWithVersionIncrement(updates);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to mark all notifications as read: ${e.toString()}');
    }
  }

  @override
  Future<void> dismissAllNotifications({
    required String userId,
    String? familyId,
  }) async {
    try {
      // Use the family-aware query
      final notifications = familyId != null
          ? await getNotificationsByFamily(
              familyId: familyId,
              userId: userId,
              includeDeleted: false,
            )
          : await getNotificationsByUser(
              userId: userId,
              includeDeleted: false,
            );

      if (notifications.isEmpty) return;

      final updates = <String, Map<String, dynamic>>{};
      final now = DateTime.now();

      for (final notification in notifications) {
        if (!notification.isDismissed) {
          updates[notification.id] = {
            FirestoreConstants.isDismissed: true,
            FirestoreConstants.dismissedAt: now,
          };
        }
      }

      // Use transaction for atomic updates with version checking
      await _batchUpdateWithVersionIncrement(updates);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to dismiss all notifications: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAllNotifications({
    required String userId,
    String? familyId,
  }) async {
    try {
      // Use the family-aware query
      final notifications = familyId != null
          ? await getNotificationsByFamily(
              familyId: familyId,
              userId: userId,
              includeDeleted: true,
            )
          : await getNotificationsByUser(
              userId: userId,
              includeDeleted: true,
            );

      if (notifications.isEmpty) return;

      // Instead of hard delete, use soft delete for consistency
      final updates = <String, Map<String, dynamic>>{};
      final now = DateTime.now();

      for (final notification in notifications) {
        if (!notification.isDeleted) {
          updates[notification.id] = {
            FirestoreConstants.isDeleted: true,
            FirestoreConstants.deletedAt: now,
          };
        }
      }

      // Use transaction for atomic updates with version checking
      await _batchUpdateWithVersionIncrement(updates);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to delete all notifications: ${e.toString()}');
    }
  }

  @override
  Future<void> createBulkNotifications({
    required List<NotificationModel> notifications,
  }) async {
    try {
      if (notifications.isEmpty) return;

      final batch = firestoreService.batch();
      final now = DateTime.now();

      for (final notification in notifications) {
        final newNotification = notification.copyWith(
          version: 1,
          createdAt: now,
          updatedAt: now,
          isRead: false,
          isDismissed: false,
        );
        
        final docRef = getDocumentReference(notification.id);
        batch.set(docRef, newNotification.toJson());
      }

      await batch.commit();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to create bulk notifications: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getNotificationStats({
    required String userId,
    String? familyId,
  }) async {
    try {
      final stats = <String, int>{
        'total': 0,
        'unread': 0,
        'read': 0,
        'dismissed': 0,
      };

      // Get notifications using family-aware query
      final allNotifications = familyId != null
          ? await getNotificationsByFamily(
              familyId: familyId,
              userId: userId,
              includeDeleted: true,
              limit: 1000,
            )
          : await getNotificationsByUser(
              userId: userId,
              includeDeleted: true,
              limit: 1000,
            );

      stats['total'] = allNotifications.length;
      stats['unread'] = allNotifications.where((n) => !n.isRead && !n.isDismissed && !n.isDeleted).length;
      stats['read'] = allNotifications.where((n) => n.isRead && !n.isDeleted).length;
      stats['dismissed'] = allNotifications.where((n) => n.isDismissed && !n.isDeleted).length;

      return stats;
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get notification stats: ${e.toString()}');
    }
  }
}
