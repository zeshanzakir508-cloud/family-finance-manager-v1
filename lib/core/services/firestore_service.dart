import 'package:cloud_firestore/cloud_firestore.dart';

/// ============================================================================
/// Family Finance Manager
/// Firestore Service
/// ----------------------------------------------------------------------------
/// Centralized wrapper around Cloud Firestore.
///
/// Responsibilities:
/// • Collection & document references
/// • CRUD operations
/// • Streams
/// • Queries
/// • Transactions
/// • Batch writes
/// • Utility helpers
///
/// NOTE:
/// Business logic belongs in repository implementations.
/// ============================================================================

class FirestoreService {
  FirestoreService({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  FirebaseFirestore get instance => _firestore;

  //==========================================================================
  // References
  //==========================================================================

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  DocumentReference<Map<String, dynamic>> document(String path) {
    return _firestore.doc(path);
  }

  CollectionReference<Map<String, dynamic>> collectionGroup(
    String collectionId,
  ) {
    throw UnsupportedError(
      'collectionGroup returns Query, use queryCollectionGroup().',
    );
  }

  Query<Map<String, dynamic>> queryCollectionGroup(
    String collectionId,
  ) {
    return _firestore.collectionGroup(collectionId);
  }

  //==========================================================================
  // Reads
  //==========================================================================

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String path,
  ) {
    return document(path).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
    String path,
  ) {
    return collection(path).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchDocument(
    String path,
  ) {
    return document(path).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchCollection(
    String path,
  ) {
    return collection(path).snapshots();
  }

  //==========================================================================
  // Writes
  //==========================================================================

  Future<void> setDocument({
    required String path,
    required Map<String, dynamic> data,
    SetOptions? options,
  }) {
    return document(path).set(
      data,
      options,
    );
  }

  Future<void> updateDocument({
    required String path,
    required Map<String, dynamic> data,
  }) {
    return document(path).update(data);
  }

  Future<void> deleteDocument(
    String path,
  ) {
    return document(path).delete();
  }

  //==========================================================================
  // Utilities
  //==========================================================================

  Future<bool> documentExists(
    String path,
  ) async {
    final snapshot = await getDocument(path);
    return snapshot.exists;
  }

  String generateId(
    String collectionPath,
  ) {
    return collection(collectionPath).doc().id;
  }

  Timestamp now() {
    return Timestamp.now();
  }

  FieldValue serverTimestamp() {
    return FieldValue.serverTimestamp();
  }

  //==========================================================================
  // Batch
  //==========================================================================

  WriteBatch batch() {
    return _firestore.batch();
  }

  Future<void> commitBatch(
    WriteBatch batch,
  ) {
    return batch.commit();
  }

  //==========================================================================
  // Transactions
  //==========================================================================

  Future<T> runTransaction<T>(
    TransactionHandler<T> handler,
  ) {
    return _firestore.runTransaction(handler);
  }

  //==========================================================================
  // Queries
  //==========================================================================

  Query<Map<String, dynamic>> query(
    String collectionPath,
  ) {
    return collection(collectionPath);
  }
}
