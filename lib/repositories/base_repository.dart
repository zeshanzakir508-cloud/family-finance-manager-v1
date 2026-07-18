import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_constants.dart';
import '../core/services/firestore_service.dart';

/// ============================================================================
/// Family Finance Manager
/// Base Repository
/// ----------------------------------------------------------------------------
/// Base class for all repository implementations.
///
/// Responsibilities:
/// • Common Firestore CRUD operations
/// • Document & collection path helpers
/// • Timestamp helpers
/// • Soft delete / restore
/// • Version increment
/// • Existence checks
///
/// Business logic MUST NOT be placed here.
/// ============================================================================
abstract class BaseRepository {
  BaseRepository({
    required FirestoreService firestoreService,
  }) : firestore = firestoreService;

  /// Shared Firestore service.
  final FirestoreService firestore;

  /// Root collection path.
  ///
  /// Example:
  /// users
  /// accounts
  /// categories
  /// transactions
  String get collectionPath;

  //==========================================================================
  // Path Helpers
  //==========================================================================

  String documentPath(String id) => '$collectionPath/$id';

  //==========================================================================
  // References
  //==========================================================================

  DocumentReference<Map<String, dynamic>> document(String id) {
    return firestore.document(documentPath(id));
  }

  CollectionReference<Map<String, dynamic>> collection() {
    return firestore.collection(collectionPath);
  }

  //==========================================================================
  // Reads
  //==========================================================================

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String id,
  ) {
    return firestore.getDocument(documentPath(id));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchDocument(
    String id,
  ) {
    return firestore.watchDocument(documentPath(id));
  }

  Future<bool> exists(
    String id,
  ) {
    return firestore.documentExists(documentPath(id));
  }

  //==========================================================================
  // Writes
  //==========================================================================

  Future<void> setDocument({
    required String id,
    required Map<String, dynamic> data,
    SetOptions? options,
  }) {
    return firestore.setDocument(
      path: documentPath(id),
      data: data,
      options: options,
    );
  }

  Future<void> updateDocument({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return firestore.updateDocument(
      path: documentPath(id),
      data: data,
    );
  }

  Future<void> deleteDocument(
    String id,
  ) {
    return firestore.deleteDocument(
      documentPath(id),
    );
  }

  //==========================================================================
  // Common Helpers
  //==========================================================================

  Map<String, dynamic> timestampUpdate() {
    return {
      FirestoreConstants.updatedAt: firestore.serverTimestamp(),
    };
  }

  Map<String, dynamic> versionUpdate(
    int currentVersion,
  ) {
    return {
      FirestoreConstants.version: currentVersion + 1,
      FirestoreConstants.updatedAt: firestore.serverTimestamp(),
    };
  }

  Map<String, dynamic> softDeleteData(
    int currentVersion,
  ) {
    return {
      FirestoreConstants.isDeleted: true,
      FirestoreConstants.deletedAt: firestore.serverTimestamp(),
      FirestoreConstants.updatedAt: firestore.serverTimestamp(),
      FirestoreConstants.version: currentVersion + 1,
    };
  }

  Map<String, dynamic> restoreData(
    int currentVersion,
  ) {
    return {
      FirestoreConstants.isDeleted: false,
      FirestoreConstants.deletedAt: null,
      FirestoreConstants.updatedAt: firestore.serverTimestamp(),
      FirestoreConstants.version: currentVersion + 1,
    };
  }

  //==========================================================================
  // Batch Helpers
  //==========================================================================

  WriteBatch batch() {
    return firestore.batch();
  }

  Future<void> commitBatch(
    WriteBatch batch,
  ) {
    return firestore.commitBatch(batch);
  }

  //==========================================================================
  // Transactions
  //==========================================================================

  Future<T> runTransaction<T>(
    TransactionHandler<T> handler,
  ) {
    return firestore.runTransaction(handler);
  }
}
