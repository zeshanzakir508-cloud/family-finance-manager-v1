import 'package:cloud_firestore/cloud_firestore.dart';

/// ============================================================================
/// Family Finance Manager
/// Firestore Service
/// ----------------------------------------------------------------------------
/// Centralized wrapper around Cloud Firestore.
///
/// Responsibilities:
/// • Collection references
/// • Document references
/// • CRUD operations
/// • Batch writes
/// • Transactions
/// • Streams
///
/// NOTE:
/// Business logic belongs in repository implementations.
/// ============================================================================

class FirestoreService {
  FirestoreService({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  /// Returns a collection reference.
  CollectionReference<Map<String, dynamic>> collection(
    String path,
  ) {
    return _firestore.collection(path);
  }

  /// Returns a document reference.
  DocumentReference<Map<String, dynamic>> document(
    String path,
  ) {
    return _firestore.doc(path);
  }

  /// Reads a document.
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String path,
  ) {
    return document(path).get();
  }

  /// Watches a document.
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchDocument(
    String path,
  ) {
    return document(path).snapshots();
  }

  /// Reads a collection.
  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
    String path,
  ) {
    return collection(path).get();
  }

  /// Watches a collection.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchCollection(
    String path,
  ) {
    return collection(path).snapshots();
  }

  /// Creates or replaces a document.
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

  /// Updates a document.
  Future<void> updateDocument({
    required String path,
    required Map<String, dynamic> data,
  }) {
    return document(path).update(data);
  }

  /// Deletes a document.
  Future<void> deleteDocument(
    String path,
  ) {
    return document(path).delete();
  }

  /// Returns a Firestore batch.
  WriteBatch batch() {
    return _firestore.batch();
  }

  /// Runs a Firestore transaction.
  Future<T> runTransaction<T>(
    TransactionHandler<T> handler,
  ) {
    return _firestore.runTransaction(handler);
  }

  /// Generates a new document ID.
  String generateId(
    String collectionPath,
  ) {
    return collection(collectionPath).doc().id;
  }

  /// Returns the current server timestamp.
  FieldValue serverTimestamp() {
    return FieldValue.serverTimestamp();
  }

  /// Returns the current timestamp.
  Timestamp now() {
    return Timestamp.now();
  }
}
