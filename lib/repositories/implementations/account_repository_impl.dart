// lib/repositories/implementations/account_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../interfaces/account_repository.dart';
import '../interfaces/base_repository.dart';
import '../../services/firestore_service.dart';
import '../../constants/firestore_constants.dart';
import '../../models/account_model.dart';
import '../../exceptions/app_exception.dart';
import '../../exceptions/firestore_exception.dart';

/// Implementation of AccountRepository that handles all account-related Firestore operations.
///
/// This repository follows the single responsibility principle and only handles
/// data persistence. All business logic should be in domain managers/use cases.
class AccountRepositoryImpl extends BaseRepository implements AccountRepository {
  AccountRepositoryImpl({
    required FirestoreService firestoreService,
  }) : super(firestoreService);

  @override
  String get collectionPath => FirestoreConstants.accounts;

  // ==================== Private Helpers ====================

  /// Updates a subset of account fields while maintaining version consistency.
  ///
  /// Why: Field-specific updates (name, type, currency, etc.) shouldn't require
  /// callers to know about versioning or timestamps. By centralizing this logic,
  /// we ensure every partial update correctly increments the version and updates
  /// the timestamp, preventing stale data from overwriting newer changes.
  ///
  /// Note: This performs a read-before-write to get the current version.
  /// For high-contention scenarios (e.g., balance updates), consider replacing
  /// with a transaction.
  Future<void> _updateFields(
    String accountId,
    Map<String, dynamic> fields,
  ) async {
    try {
      // Read the current account state to get the latest version
      final account = await getAccount(accountId);
      if (account == null) {
        throw AppException('Account not found: $accountId');
      }

      final now = DateTime.now();
      final updateData = {
        ...fields,
        FirestoreConstants.updatedAt: now,
        FirestoreConstants.version: account.version + 1,
      };

      await updateDocument(accountId, updateData);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update account fields for $accountId: ${e.toString()}');
    }
  }

  /// Updates account balance using a transaction for atomicity.
  ///
  /// Why: Balance updates require atomic read-modify-write operations to prevent
  /// race conditions when multiple transactions modify the same account
  /// simultaneously. Using a transaction ensures the balance is always consistent.
  Future<void> _updateBalance(
    String accountId,
    double newBalance,
  ) async {
    try {
      final docRef = getDocumentReference(accountId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Account not found: $accountId');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        final updateData = {
          FirestoreConstants.balance: newBalance,
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
      throw AppException('Failed to update balance for account $accountId: ${e.toString()}');
    }
  }

  /// Updates account tags using a transaction for atomicity.
  ///
  /// Why: Tag updates should be atomic and prevent duplicate entries.
  /// Using arrayUnion/arrayRemove with a transaction ensures consistency.
  Future<void> _updateTags(
    String accountId,
    List<String> tagsToAdd,
    List<String> tagsToRemove,
  ) async {
    try {
      final docRef = getDocumentReference(accountId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Account not found: $accountId');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        final updateData = <String, dynamic>{
          FirestoreConstants.updatedAt: now,
          FirestoreConstants.version: currentVersion + 1,
        };

        if (tagsToAdd.isNotEmpty) {
          updateData[FirestoreConstants.tags] = FieldValue.arrayUnion(tagsToAdd);
        }

        if (tagsToRemove.isNotEmpty) {
          updateData[FirestoreConstants.tags] = FieldValue.arrayRemove(tagsToRemove);
        }

        transaction.update(docRef, updateData);
      });
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update tags for account $accountId: ${e.toString()}');
    }
  }

  // ==================== Public Methods ====================

  @override
  Future<void> createAccount(AccountModel account) async {
    try {
      final now = DateTime.now();
      
      // Keep versioning and timestamp management inside the repository
      // so callers don't need to maintain persistence metadata.
      final newAccount = account.copyWith(
        version: 1,
        createdAt: now,
        updatedAt: now,
      );
      
      await setDocument(
        account.id,
        newAccount.toJson(),
      );
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to create account ${account.id}: ${e.toString()}');
    }
  }

  @override
  Future<AccountModel?> getAccount(String accountId) async {
    try {
      final doc = await getDocument(accountId);
      if (!doc.exists) return null;
      return AccountModel.fromJson(doc.data()!);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get account $accountId: ${e.toString()}');
    }
  }

  @override
  Stream<AccountModel?> watchAccount(String accountId) {
    // Real-time updates are mapped to domain models, never exposing raw
    // Firestore documents to the rest of the application.
    return watchDocument(accountId).map((doc) {
      if (!doc.exists) return null;
      return AccountModel.fromJson(doc.data()!);
    });
  }

  @override
  Future<void> updateAccount(AccountModel account) async {
    try {
      // Read the current state to ensure we don't overwrite a newer version.
      final existing = await getAccount(account.id);
      if (existing == null) {
        throw AppException('Account not found: ${account.id}');
      }

      final now = DateTime.now();
      final updatedAccount = account.copyWith(
        updatedAt: now,
        version: existing.version + 1,
      );
      
      await updateDocument(account.id, updatedAccount.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update account ${account.id}: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    try {
      final account = await getAccount(accountId);
      if (account == null) {
        throw AppException('Account not found: $accountId');
      }

      final now = DateTime.now();
      
      // Soft delete preserves the document for audit trails and potential
      // restoration, rather than permanently removing data.
      final updatedAccount = account.copyWith(
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
        version: account.version + 1,
      );
      
      await updateDocument(accountId, updatedAccount.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to delete account $accountId: ${e.toString()}');
    }
  }

  @override
  Future<void> restoreAccount(String accountId) async {
    try {
      final account = await getAccount(accountId);
      if (account == null) {
        throw AppException('Account not found: $accountId');
      }

      final now = DateTime.now();
      final updatedAccount = account.copyWith(
        isDeleted: false,
        deletedAt: null,
        updatedAt: now,
        version: account.version + 1,
      );
      
      await updateDocument(accountId, updatedAccount.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to restore account $accountId: ${e.toString()}');
    }
  }

  @override
  Future<bool> accountExists(String accountId) async {
    try {
      return await documentExists(accountId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to check account existence for $accountId: ${e.toString()}');
    }
  }

  // ==================== Account-Specific Methods ====================

  @override
  Future<void> updateAccountName({
    required String accountId,
    required String name,
  }) async {
    await _updateFields(
      accountId,
      {FirestoreConstants.accountName: name},
    );
  }

  @override
  Future<void> updateAccountType({
    required String accountId,
    required String accountType,
  }) async {
    await _updateFields(
      accountId,
      {FirestoreConstants.accountType: accountType},
    );
  }

  @override
  Future<void> updateAccountCurrency({
    required String accountId,
    required String currencyCode,
  }) async {
    await _updateFields(
      accountId,
      {FirestoreConstants.currencyCode: currencyCode},
    );
  }

  @override
  Future<void> updateAccountBalance({
    required String accountId,
    required double balance,
  }) async {
    await _updateBalance(accountId, balance);
  }

  @override
  Future<void> updateAccountDescription({
    required String accountId,
    required String? description,
  }) async {
    await _updateFields(
      accountId,
      {FirestoreConstants.description: description},
    );
  }

  @override
  Future<void> setAccountActive({
    required String accountId,
    required bool isActive,
  }) async {
    await _updateFields(
      accountId,
      {FirestoreConstants.isActive: isActive},
    );
  }

  @override
  Future<void> addAccountTag({
    required String accountId,
    required String tag,
  }) async {
    await _updateTags(
      accountId,
      [tag],
      [],
    );
  }

  @override
  Future<void> removeAccountTag({
    required String accountId,
    required String tag,
  }) async {
    await _updateTags(
      accountId,
      [],
      [tag],
    );
  }

  @override
  Future<List<AccountModel>> getAccountsByFamily(String familyId) async {
    try {
      final docs = await getDocuments(
        where: FirestoreConstants.familyId,
        isEqualTo: familyId,
        where: FirestoreConstants.isDeleted,
        isEqualTo: false,
      );
      
      return docs
          .where((doc) => doc.exists)
          .map((doc) => AccountModel.fromJson(doc.data()!))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get accounts for family $familyId: ${e.toString()}');
    }
  }

  @override
  Future<List<AccountModel>> getActiveAccountsByFamily(String familyId) async {
    try {
      final docs = await getDocuments(
        where: FirestoreConstants.familyId,
        isEqualTo: familyId,
        where: FirestoreConstants.isActive,
        isEqualTo: true,
        where: FirestoreConstants.isDeleted,
        isEqualTo: false,
      );
      
      return docs
          .where((doc) => doc.exists)
          .map((doc) => AccountModel.fromJson(doc.data()!))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get active accounts for family $familyId: ${e.toString()}');
    }
  }
}
