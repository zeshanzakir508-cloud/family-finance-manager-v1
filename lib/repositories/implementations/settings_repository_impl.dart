// lib/repositories/implementations/settings_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../interfaces/settings_repository.dart';
import '../interfaces/base_repository.dart';
import '../../services/firestore_service.dart';
import '../../constants/firestore_constants.dart';
import '../../models/settings_model.dart';
import '../../exceptions/app_exception.dart';
import '../../exceptions/firestore_exception.dart';

/// Implementation of SettingsRepository that handles all settings-related Firestore operations.
///
/// This repository follows the single responsibility principle and only handles
/// data persistence. All business logic should be in domain managers/use cases.
///
/// Settings store user preferences, app configurations, and feature flags.
/// Settings are typically stored as key-value pairs grouped by category
/// (e.g., appearance, notifications, privacy, etc.).
class SettingsRepositoryImpl extends BaseRepository implements SettingsRepository {
  SettingsRepositoryImpl({
    required FirestoreService firestoreService,
  }) : super(firestoreService);

  @override
  String get collectionPath => FirestoreConstants.settings;

  // ==================== Private Helpers ====================

  /// Updates a subset of settings fields while maintaining version consistency
  /// using a transaction for atomicity.
  ///
  /// Why: Using a transaction ensures the version is read and incremented atomically,
  /// preventing race conditions when multiple clients update settings simultaneously.
  Future<void> _updateFieldsWithTransaction(
    String settingsId,
    Map<String, dynamic> fields,
  ) async {
    try {
      final docRef = getDocumentReference(settingsId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Settings not found: $settingsId');
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
      throw AppException('Failed to update settings fields for $settingsId: ${e.toString()}');
    }
  }

  /// Performs a full settings update using a transaction for atomicity.
  ///
  /// Why: Like partial updates, full updates should be atomic to prevent
  /// race conditions with concurrent modifications.
  Future<void> _updateFullSettings(
    SettingsModel settings,
  ) async {
    try {
      final docRef = getDocumentReference(settings.id);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Settings not found: ${settings.id}');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        final updatedSettings = settings.copyWith(
          updatedAt: now,
          version: currentVersion + 1,
        );
        
        transaction.update(docRef, updatedSettings.toJson());
      });
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update settings ${settings.id}: ${e.toString()}');
    }
  }

  /// Merges new values into existing settings using a transaction for atomicity.
  ///
  /// Why: The entire read-merge-write cycle must be atomic to prevent
  /// lost updates when multiple clients modify settings simultaneously.
  Future<void> _mergeSettingsWithTransaction({
    required String settingsId,
    required Map<String, dynamic> newValues,
  }) async {
    try {
      final docRef = getDocumentReference(settingsId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Settings not found: $settingsId');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        // Read current values inside the transaction
        final currentValues = Map<String, dynamic>.from(
          doc.data()?[FirestoreConstants.values] as Map? ?? {},
        );
        
        // Merge new values inside the transaction
        currentValues.addAll(newValues);
        
        final updateData = {
          FirestoreConstants.values: currentValues,
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
      throw AppException('Failed to merge settings: ${e.toString()}');
    }
  }

  /// Replaces all settings values with new ones using a transaction for atomicity.
  ///
  /// Why: Replacement should be atomic to prevent race conditions with
  /// concurrent modifications.
  Future<void> _replaceSettingsWithTransaction({
    required String settingsId,
    required Map<String, dynamic> newValues,
  }) async {
    try {
      final docRef = getDocumentReference(settingsId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Settings not found: $settingsId');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        final updateData = {
          FirestoreConstants.values: newValues,
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
      throw AppException('Failed to replace settings: ${e.toString()}');
    }
  }

  /// Removes a specific key from settings using a transaction for atomicity.
  ///
  /// Why: The read-modify-write cycle must be atomic to prevent lost updates.
  Future<void> _removeSettingKeyWithTransaction({
    required String settingsId,
    required String key,
  }) async {
    try {
      final docRef = getDocumentReference(settingsId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Settings not found: $settingsId');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        // Read current values inside the transaction
        final currentValues = Map<String, dynamic>.from(
          doc.data()?[FirestoreConstants.values] as Map? ?? {},
        );
        
        // Remove the key inside the transaction
        currentValues.remove(key);
        
        final updateData = {
          FirestoreConstants.values: currentValues,
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
      throw AppException('Failed to remove setting key: ${e.toString()}');
    }
  }

  /// Performs a soft delete using a transaction for atomicity.
  ///
  /// Why: Soft deletes should be atomic to prevent race conditions with
  /// concurrent updates or multiple delete attempts.
  Future<void> _softDeleteWithTransaction(String settingsId) async {
    try {
      final docRef = getDocumentReference(settingsId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Settings not found: $settingsId');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        final updateData = {
          FirestoreConstants.isDeleted: true,
          FirestoreConstants.deletedAt: now,
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
      throw AppException('Failed to delete settings $settingsId: ${e.toString()}');
    }
  }

  /// Performs a restore using a transaction for atomicity.
  ///
  /// Why: Restores should be atomic to prevent race conditions with
  /// concurrent updates or multiple restore attempts.
  Future<void> _restoreWithTransaction(String settingsId) async {
    try {
      final docRef = getDocumentReference(settingsId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Settings not found: $settingsId');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        final updateData = {
          FirestoreConstants.isDeleted: false,
          FirestoreConstants.deletedAt: null,
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
      throw AppException('Failed to restore settings $settingsId: ${e.toString()}');
    }
  }

  /// Builds a query with common settings filters.
  Query _buildSettingsQuery({
    required String userId,
    String? category,
    bool includeDeleted = false,
  }) {
    final collection = firestoreService.collection(collectionPath);
    Query query = collection
        .where(FirestoreConstants.userId, isEqualTo: userId);

    if (!includeDeleted) {
      query = query.where(FirestoreConstants.isDeleted, isEqualTo: false);
    }

    if (category != null) {
      query = query.where(FirestoreConstants.category, isEqualTo: category);
    }

    return query;
  }

  // ==================== Public Methods ====================

  @override
  Future<void> createSettings(SettingsModel settings) async {
    try {
      final now = DateTime.now();
      
      final newSettings = settings.copyWith(
        version: 1,
        createdAt: now,
        updatedAt: now,
      );
      
      await setDocument(
        settings.id,
        newSettings.toJson(),
      );
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to create settings ${settings.id}: ${e.toString()}');
    }
  }

  @override
  Future<SettingsModel?> getSettings(String settingsId) async {
    try {
      final doc = await getDocument(settingsId);
      if (!doc.exists) return null;
      return SettingsModel.fromJson(doc.data()!);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get settings $settingsId: ${e.toString()}');
    }
  }

  @override
  Future<SettingsModel?> getSettingsByUser(String userId) async {
    try {
      final query = _buildSettingsQuery(
        userId: userId,
        includeDeleted: false,
      );

      final docs = await query
          .orderBy(FirestoreConstants.createdAt, descending: true)
          .limit(1)
          .get();

      if (docs.docs.isEmpty) return null;
      
      final doc = docs.docs.first;
      if (!doc.exists) return null;
      
      return SettingsModel.fromJson(doc.data());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get settings for user $userId: ${e.toString()}');
    }
  }

  @override
  Stream<SettingsModel?> watchSettingsByUser(String userId) {
    try {
      final query = _buildSettingsQuery(
        userId: userId,
        includeDeleted: false,
      ).orderBy(FirestoreConstants.createdAt, descending: true).limit(1);

      return query.snapshots().map((snapshot) {
        if (snapshot.docs.isEmpty) return null;
        final doc = snapshot.docs.first;
        if (!doc.exists) return null;
        return SettingsModel.fromJson(doc.data());
      });
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to watch settings for user $userId: ${e.toString()}');
    }
  }

  @override
  Future<void> updateSettings(SettingsModel settings) async {
    try {
      await _updateFullSettings(settings);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update settings ${settings.id}: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteSettings(String settingsId) async {
    try {
      await _softDeleteWithTransaction(settingsId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to delete settings $settingsId: ${e.toString()}');
    }
  }

  @override
  Future<void> restoreSettings(String settingsId) async {
    try {
      await _restoreWithTransaction(settingsId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to restore settings $settingsId: ${e.toString()}');
    }
  }

  @override
  Future<bool> settingsExists(String settingsId) async {
    try {
      return await documentExists(settingsId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to check settings existence for $settingsId: ${e.toString()}');
    }
  }

  @override
  Future<bool> userHasSettings(String userId) async {
    try {
      final settings = await getSettingsByUser(userId);
      return settings != null;
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to check if user $userId has settings: ${e.toString()}');
    }
  }

  // ==================== Settings Management Methods ====================

  @override
  Future<void> updateSettingValue({
    required String settingsId,
    required String key,
    required dynamic value,
  }) async {
    await _mergeSettingsWithTransaction(
      settingsId: settingsId,
      newValues: {key: value},
    );
  }

  @override
  Future<void> updateSettingsCategory({
    required String settingsId,
    required String category,
  }) async {
    await _updateFieldsWithTransaction(
      settingsId,
      {FirestoreConstants.category: category},
    );
  }

  @override
  Future<void> batchUpdateSettings({
    required String settingsId,
    required Map<String, dynamic> updates,
  }) async {
    if (updates.isEmpty) return;
    
    await _mergeSettingsWithTransaction(
      settingsId: settingsId,
      newValues: updates,
    );
  }

  @override
  Future<void> removeSettingValue({
    required String settingsId,
    required String key,
  }) async {
    await _removeSettingKeyWithTransaction(
      settingsId: settingsId,
      key: key,
    );
  }

  @override
  Future<dynamic> getSettingValue({
    required String settingsId,
    required String key,
    dynamic defaultValue,
  }) async {
    final settings = await getSettings(settingsId);
    if (settings == null) {
      return defaultValue;
    }
    return settings.values?[key] ?? defaultValue;
  }

  @override
  Future<SettingsModel?> getSettingsByCategory({
    required String userId,
    required String category,
  }) async {
    try {
      final query = _buildSettingsQuery(
        userId: userId,
        category: category,
        includeDeleted: false,
      );

      final docs = await query
          .orderBy(FirestoreConstants.createdAt, descending: true)
          .limit(1)
          .get();

      if (docs.docs.isEmpty) return null;
      
      final doc = docs.docs.first;
      if (!doc.exists) return null;
      
      return SettingsModel.fromJson(doc.data());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get settings by category for user $userId: ${e.toString()}');
    }
  }

  @override
  Future<void> resetSettingsToDefault({
    required String settingsId,
    required Map<String, dynamic> defaultValues,
  }) async {
    await _replaceSettingsWithTransaction(
      settingsId: settingsId,
      newValues: defaultValues,
    );
  }

  @override
  Future<void> mergeSettings({
    required String settingsId,
    required Map<String, dynamic> newValues,
  }) async {
    if (newValues.isEmpty) return;
    
    await _mergeSettingsWithTransaction(
      settingsId: settingsId,
      newValues: newValues,
    );
  }

  @override
  Future<List<SettingsModel>> getAllUserSettings(String userId) async {
    try {
      final query = _buildSettingsQuery(
        userId: userId,
        includeDeleted: false,
      );

      final docs = await query
          .orderBy(FirestoreConstants.category, descending: false)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => SettingsModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get all settings for user $userId: ${e.toString()}');
    }
  }
}
