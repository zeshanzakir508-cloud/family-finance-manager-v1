// lib/repositories/implementations/user_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../interfaces/user_repository.dart';
import '../interfaces/base_repository.dart';
import '../../services/firestore_service.dart';
import '../../constants/firestore_constants.dart';
import '../../models/user_model.dart';
import '../../exceptions/app_exception.dart';
import '../../exceptions/firestore_exception.dart';

/// Implementation of UserRepository that handles all user-related Firestore operations.
///
/// This repository follows the single responsibility principle and only handles
/// data persistence. All business logic should be in domain managers/use cases.
class UserRepositoryImpl extends BaseRepository implements UserRepository {
  final FirebaseAuth _auth;

  UserRepositoryImpl({
    required FirestoreService firestoreService,
    required FirebaseAuth auth,
  })  : _auth = auth,
        super(firestoreService);

  @override
  String get collectionPath => FirestoreConstants.users;

  // ==================== Private Helpers ====================

  /// Updates a subset of user fields while maintaining version consistency.
  ///
  /// Why: Field-specific updates (display name, photo, etc.) shouldn't require
  /// callers to know about versioning or timestamps. By centralizing this logic,
  /// we ensure every partial update correctly increments the version and updates
  /// the timestamp, preventing stale data from overwriting newer changes.
  ///
  /// Note: This performs a read-before-write to get the current version.
  /// For high-contention scenarios, consider replacing with a transaction.
  Future<void> _updateFields(
    String userId,
    Map<String, dynamic> fields,
  ) async {
    try {
      // Read the current user state to get the latest version
      final user = await getUser(userId);
      if (user == null) {
        throw AppException('User not found: $userId');
      }

      final now = DateTime.now();
      final updateData = {
        ...fields,
        FirestoreConstants.updatedAt: now,
        FirestoreConstants.version: user.version + 1,
      };

      await updateDocument(userId, updateData);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update user fields for $userId: ${e.toString()}');
    }
  }

  // ==================== Public Methods ====================

  @override
  Future<void> createUser(UserModel user) async {
    try {
      final now = DateTime.now();
      
      // Keep versioning and timestamp management inside the repository
      // so callers don't need to maintain persistence metadata.
      final newUser = user.copyWith(
        version: 1,
        createdAt: now,
        updatedAt: now,
      );
      
      await setDocument(
        user.id,
        newUser.toJson(),
      );
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to create user ${user.id}: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await getDocument(userId);
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get user $userId: ${e.toString()}');
    }
  }

  @override
  Stream<UserModel?> watchUser(String userId) {
    // Real-time updates are mapped to domain models, never exposing raw
    // Firestore documents to the rest of the application.
    return watchDocument(userId).map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    });
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      // Read the current state to ensure we don't overwrite a newer version.
      // This is version tracking, not optimistic locking - we're not preventing
      // concurrent updates, but we're ensuring the version increments correctly
      // from the current state.
      final existing = await getUser(user.id);
      if (existing == null) {
        throw AppException('User not found: ${user.id}');
      }

      final now = DateTime.now();
      final updatedUser = user.copyWith(
        updatedAt: now,
        version: existing.version + 1,
      );
      
      // updateDocument() uses Firestore's update() method internally.
      // If the document has been deleted, this will throw a FirebaseException.
      await updateDocument(user.id, updatedUser.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update user ${user.id}: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      final user = await getUser(userId);
      if (user == null) {
        throw AppException('User not found: $userId');
      }

      final now = DateTime.now();
      
      // Soft delete preserves the document for audit trails and potential
      // restoration, rather than permanently removing data.
      final updatedUser = user.copyWith(
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
        version: user.version + 1,
      );
      
      await updateDocument(userId, updatedUser.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to delete user $userId: ${e.toString()}');
    }
  }

  @override
  Future<void> restoreUser(String userId) async {
    try {
      final user = await getUser(userId);
      if (user == null) {
        throw AppException('User not found: $userId');
      }

      final now = DateTime.now();
      final updatedUser = user.copyWith(
        isDeleted: false,
        deletedAt: null,
        updatedAt: now,
        version: user.version + 1,
      );
      
      await updateDocument(userId, updatedUser.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to restore user $userId: ${e.toString()}');
    }
  }

  @override
  Future<bool> userExists(String userId) async {
    try {
      return await documentExists(userId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to check user existence for $userId: ${e.toString()}');
    }
  }

  @override
  Future<void> updateDisplayName({
    required String userId,
    required String displayName,
  }) async {
    await _updateFields(
      userId,
      {FirestoreConstants.displayName: displayName},
    );
  }

  @override
  Future<void> updatePhotoUrl({
    required String userId,
    required String photoUrl,
  }) async {
    await _updateFields(
      userId,
      {FirestoreConstants.photoUrl: photoUrl},
    );
  }

  @override
  Future<void> updateLanguage({
    required String userId,
    required String languageCode,
  }) async {
    await _updateFields(
      userId,
      {FirestoreConstants.languageCode: languageCode},
    );
  }

  @override
  Future<void> setEmailVerified({
    required String userId,
    required bool verified,
  }) async {
    await _updateFields(
      userId,
      {FirestoreConstants.emailVerified: verified},
    );
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;
      return getUser(firebaseUser.uid);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get current user: ${e.toString()}');
    }
  }
}
