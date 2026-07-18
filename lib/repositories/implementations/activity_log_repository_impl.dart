// lib/repositories/implementations/activity_log_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../interfaces/activity_log_repository.dart';
import '../interfaces/base_repository.dart';
import '../../services/firestore_service.dart';
import '../../constants/firestore_constants.dart';
import '../../models/activity_log_model.dart';
import '../../exceptions/app_exception.dart';
import '../../exceptions/firestore_exception.dart';

/// Implementation of ActivityLogRepository that handles all activity log-related Firestore operations.
///
/// This repository follows the single responsibility principle and only handles
/// data persistence. All business logic should be in domain managers/use cases.
///
/// Activity logs track user actions across the application for audit purposes.
/// They capture who did what, when, and on which entity. Logs are immutable
/// (they are never updated after creation) and are typically used for
/// compliance, debugging, and user activity monitoring.
class ActivityLogRepositoryImpl extends BaseRepository implements ActivityLogRepository {
  ActivityLogRepositoryImpl({
    required FirestoreService firestoreService,
  }) : super(firestoreService);

  @override
  String get collectionPath => FirestoreConstants.activityLogs;

  // ==================== Private Helpers ====================

  /// Builds a query with common activity log filters.
  ///
  /// Why: Centralizing query construction reduces duplication across
  /// multiple query methods and ensures consistent filtering.
  Query _buildActivityLogQuery({
    required String familyId,
    String? userId,
    String? action,
    String? entityType,
    String? entityId,
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

    if (userId != null) {
      query = query.where(FirestoreConstants.userId, isEqualTo: userId);
    }

    if (action != null) {
      query = query.where(FirestoreConstants.action, isEqualTo: action);
    }

    if (entityType != null) {
      query = query.where(FirestoreConstants.entityType, isEqualTo: entityType);
    }

    if (entityId != null) {
      query = query.where(FirestoreConstants.entityId, isEqualTo: entityId);
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

  /// Performs a batch soft delete with version increment using a transaction.
  ///
  /// Why: This ensures versions are incremented atomically, preventing
  /// race conditions when multiple clients modify logs simultaneously.
  Future<void> _batchSoftDeleteWithVersionIncrement(
    List<ActivityLogModel> logs,
  ) async {
    if (logs.isEmpty) return;

    final updates = <String, Map<String, dynamic>>{};
    final now = DateTime.now();

    for (final log in logs) {
      if (!log.isDeleted) {
        updates[log.id] = {
          FirestoreConstants.isDeleted: true,
          FirestoreConstants.deletedAt: now,
          FirestoreConstants.updatedAt: now,
        };
      }
    }

    if (updates.isEmpty) return;

    await runTransaction((transaction) async {
      final updateData = <String, Map<String, dynamic>>{};

      for (final entry in updates.entries) {
        final docRef = getDocumentReference(entry.key);
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Activity log not found: ${entry.key}');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final data = {
          ...entry.value,
          FirestoreConstants.version: currentVersion + 1,
        };

        updateData[entry.key] = data;
      }

      for (final entry in updateData.entries) {
        final docRef = getDocumentReference(entry.key);
        transaction.update(docRef, entry.value);
      }
    });
  }

  /// Splits a list into chunks of a specified size.
  ///
  /// Why: Firestore batch operations are limited to 500 operations.
  /// Chunking ensures we don't exceed this limit.
  List<List<T>> _chunkList<T>(List<T> items, int chunkSize) {
    final chunks = <List<T>>[];
    for (var i = 0; i < items.length; i += chunkSize) {
      final end = (i + chunkSize < items.length) ? i + chunkSize : items.length;
      chunks.add(items.sublist(i, end));
    }
    return chunks;
  }

  /// Deletes a batch of logs using pagination with snapshot-based pagination.
  ///
  /// Why: This method handles large datasets by paginating through
  /// logs in chunks. Using snapshot-based pagination ensures we don't
  /// miss documents when mutating the dataset during pagination.
  Future<void> _deleteLogsWithPagination({
    required String familyId,
    required DateTime olderThan,
    int batchSize = 500,
  }) async {
    bool hasMore = true;
    DocumentSnapshot? lastDoc;

    // Use a consistent ordering to ensure predictable pagination
    final orderField = FirestoreConstants.createdAt;
    final orderDirection = true; // ascending

    while (hasMore) {
      // Build query for this batch
      var query = _buildActivityLogQuery(
        familyId: familyId,
        includeDeleted: false,
        startDate: DateTime.fromMillisecondsSinceEpoch(0),
        endDate: olderThan,
      ).orderBy(orderField, descending: !orderDirection);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      // Get next batch of logs
      final docs = await query.limit(batchSize).get();
      
      if (docs.docs.isEmpty) {
        hasMore = false;
        break;
      }

      // Store the snapshot of the last document BEFORE deletion
      // This ensures consistent pagination even as documents are modified
      lastDoc = docs.docs.last;

      // Convert to models
      final logs = docs.docs
          .where((doc) => doc.exists)
          .map((doc) => ActivityLogModel.fromJson(doc.data()))
          .toList();

      // Delete this batch
      if (logs.isNotEmpty) {
        final chunks = _chunkList(logs, 500);
        for (final chunk in chunks) {
          await _batchSoftDeleteWithVersionIncrement(chunk);
        }
      }

      // If we got fewer than batchSize documents, we've reached the end
      if (docs.docs.length < batchSize) {
        hasMore = false;
      }
    }
  }

  // ==================== Public Methods ====================

  @override
  Future<void> createActivityLog(ActivityLogModel activityLog) async {
    try {
      final now = DateTime.now();

      // Activity logs are immutable - they never change after creation
      final newLog = activityLog.copyWith(
        version: 1,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      await setDocument(
        activityLog.id,
        newLog.toJson(),
      );
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to create activity log ${activityLog.id}: ${e.toString()}');
    }
  }

  @override
  Future<ActivityLogModel?> getActivityLog(String logId) async {
    try {
      final doc = await getDocument(logId);
      if (!doc.exists) return null;
      return ActivityLogModel.fromJson(doc.data()!);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get activity log $logId: ${e.toString()}');
    }
  }

  @override
  Stream<ActivityLogModel?> watchActivityLog(String logId) {
    return watchDocument(logId).map((doc) {
      if (!doc.exists) return null;
      return ActivityLogModel.fromJson(doc.data()!);
    });
  }

  @override
  Future<void> deleteActivityLog(String logId) async {
    try {
      final log = await getActivityLog(logId);
      if (log == null) {
        throw AppException('Activity log not found: $logId');
      }

      final now = DateTime.now();

      // Soft delete for audit trail preservation
      final updatedLog = log.copyWith(
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
        version: log.version + 1,
      );

      await updateDocument(logId, updatedLog.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to delete activity log $logId: ${e.toString()}');
    }
  }

  @override
  Future<void> restoreActivityLog(String logId) async {
    try {
      final log = await getActivityLog(logId);
      if (log == null) {
        throw AppException('Activity log not found: $logId');
      }

      final now = DateTime.now();
      final updatedLog = log.copyWith(
        isDeleted: false,
        deletedAt: null,
        updatedAt: now,
        version: log.version + 1,
      );

      await updateDocument(logId, updatedLog.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to restore activity log $logId: ${e.toString()}');
    }
  }

  @override
  Future<bool> activityLogExists(String logId) async {
    try {
      return await documentExists(logId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to check activity log existence for $logId: ${e.toString()}');
    }
  }

  // ==================== Query Methods ====================

  @override
  Future<List<ActivityLogModel>> getLogsByFamily({
    required String familyId,
    bool includeDeleted = false,
    int limit = 100,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildActivityLogQuery(
        familyId: familyId,
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
          .map((doc) => ActivityLogModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get logs for family $familyId: ${e.toString()}');
    }
  }

  @override
  Future<List<ActivityLogModel>> getLogsByUser({
    required String familyId,
    required String userId,
    bool includeDeleted = false,
    int limit = 100,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildActivityLogQuery(
        familyId: familyId,
        userId: userId,
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
          .map((doc) => ActivityLogModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get logs for user $userId: ${e.toString()}');
    }
  }

  @override
  Future<List<ActivityLogModel>> getLogsByAction({
    required String familyId,
    required String action,
    bool includeDeleted = false,
    int limit = 100,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildActivityLogQuery(
        familyId: familyId,
        action: action,
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
          .map((doc) => ActivityLogModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get logs for action $action: ${e.toString()}');
    }
  }

  @override
  Future<List<ActivityLogModel>> getLogsByEntity({
    required String familyId,
    required String entityType,
    required String entityId,
    bool includeDeleted = false,
    int limit = 100,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildActivityLogQuery(
        familyId: familyId,
        entityType: entityType,
        entityId: entityId,
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
          .map((doc) => ActivityLogModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get logs for entity $entityType/$entityId: ${e.toString()}');
    }
  }

  @override
  Future<List<ActivityLogModel>> getLogsByDateRange({
    required String familyId,
    required DateTime startDate,
    required DateTime endDate,
    String? userId,
    String? action,
    String? entityType,
    bool includeDeleted = false,
    int limit = 100,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildActivityLogQuery(
        familyId: familyId,
        userId: userId,
        action: action,
        entityType: entityType,
        startDate: startDate,
        endDate: endDate,
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
          .map((doc) => ActivityLogModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get logs by date range: ${e.toString()}');
    }
  }

  @override
  Future<List<ActivityLogModel>> getRecentLogs({
    required String familyId,
    required int count,
    bool includeDeleted = false,
  }) async {
    try {
      final query = _buildActivityLogQuery(
        familyId: familyId,
        includeDeleted: includeDeleted,
      );

      final docs = await query
          .orderBy(FirestoreConstants.createdAt, descending: true)
          .limit(count)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => ActivityLogModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get recent logs for family $familyId: ${e.toString()}');
    }
  }

  @override
  Stream<List<ActivityLogModel>> watchLogsByFamily({
    required String familyId,
    bool includeDeleted = false,
  }) {
    try {
      final query = _buildActivityLogQuery(
        familyId: familyId,
        includeDeleted: includeDeleted,
      ).orderBy(FirestoreConstants.createdAt, descending: true);

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .where((doc) => doc.exists)
            .map((doc) => ActivityLogModel.fromJson(doc.data()))
            .toList();
      });
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to watch logs for family $familyId: ${e.toString()}');
    }
  }

  @override
  Future<int> getLogCount({
    required String familyId,
    String? userId,
    String? action,
    DateTime? startDate,
    DateTime? endDate,
    bool includeDeleted = false,
  }) async {
    try {
      var query = _buildActivityLogQuery(
        familyId: familyId,
        userId: userId,
        action: action,
        startDate: startDate,
        endDate: endDate,
        includeDeleted: includeDeleted,
      );

      final snapshot = await query.count().get();
      return snapshot.count;
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get log count: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteOldLogs({
    required String familyId,
    required DateTime olderThan,
  }) async {
    try {
      await _deleteLogsWithPagination(
        familyId: familyId,
        olderThan: olderThan,
      );
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to delete old logs: ${e.toString()}');
    }
  }

  @override
  Future<void> createBatchLogs({
    required List<ActivityLogModel> logs,
  }) async {
    try {
      if (logs.isEmpty) return;

      final chunks = _chunkList(logs, 500);

      for (final chunk in chunks) {
        final batch = firestoreService.batch();
        final now = DateTime.now();

        for (final log in chunk) {
          final newLog = log.copyWith(
            version: 1,
            createdAt: now,
            updatedAt: now,
            isDeleted: false,
          );

          final docRef = getDocumentReference(log.id);
          batch.set(docRef, newLog.toJson());
        }

        await batch.commit();
      }
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to create batch logs: ${e.toString()}');
    }
  }
}
