// lib/repositories/implementations/transaction_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../interfaces/transaction_repository.dart';
import '../interfaces/base_repository.dart';
import '../../services/firestore_service.dart';
import '../../constants/firestore_constants.dart';
import '../../models/transaction_model.dart';
import '../../models/account_model.dart';
import '../../exceptions/app_exception.dart';
import '../../exceptions/firestore_exception.dart';

/// Implementation of TransactionRepository that handles all transaction-related Firestore operations.
///
/// This repository follows the single responsibility principle and only handles
/// data persistence. All business logic should be in domain managers/use cases.
///
/// Note: This repository only manages transaction documents. Balance updates
/// for accounts should be handled by a domain manager (e.g., TransactionManager)
/// that coordinates between TransactionRepository and AccountRepository.
class TransactionRepositoryImpl extends BaseRepository implements TransactionRepository {
  TransactionRepositoryImpl({
    required FirestoreService firestoreService,
  }) : super(firestoreService);

  @override
  String get collectionPath => FirestoreConstants.transactions;

  // ==================== Private Helpers ====================

  /// Updates a subset of transaction fields while maintaining version consistency.
  ///
  /// Why: Field-specific updates (description, category, notes, etc.) shouldn't require
  /// callers to know about versioning or timestamps. By centralizing this logic,
  /// we ensure every partial update correctly increments the version and updates
  /// the timestamp, preventing stale data from overwriting newer changes.
  Future<void> _updateFields(
    String transactionId,
    Map<String, dynamic> fields,
  ) async {
    try {
      final transaction = await getTransaction(transactionId);
      if (transaction == null) {
        throw AppException('Transaction not found: $transactionId');
      }

      final now = DateTime.now();
      final updateData = {
        ...fields,
        FirestoreConstants.updatedAt: now,
        FirestoreConstants.version: transaction.version + 1,
      };

      await updateDocument(transactionId, updateData);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update transaction fields for $transactionId: ${e.toString()}');
    }
  }

  /// Builds a query with common transaction filters.
  ///
  /// Why: Centralizing query construction reduces duplication across
  /// multiple query methods and ensures consistent filtering (e.g.,
  /// always excluding soft-deleted transactions).
  Query _buildTransactionQuery({
    required String familyId,
    String? accountId,
    String? categoryId,
    String? type,
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

    if (accountId != null) {
      query = query.where(FirestoreConstants.accountId, isEqualTo: accountId);
    }

    if (categoryId != null) {
      query = query.where(FirestoreConstants.categoryId, isEqualTo: categoryId);
    }

    if (type != null) {
      query = query.where(FirestoreConstants.type, isEqualTo: type);
    }

    if (startDate != null) {
      query = query.where(
        FirestoreConstants.transactionDate,
        isGreaterThanOrEqualTo: startDate,
      );
    }

    if (endDate != null) {
      query = query.where(
        FirestoreConstants.transactionDate,
        isLessThanOrEqualTo: endDate,
      );
    }

    return query;
  }

  // ==================== Public Methods ====================

  @override
  Future<void> createTransaction(TransactionModel transaction) async {
    try {
      final now = DateTime.now();
      
      final newTransaction = transaction.copyWith(
        version: 1,
        createdAt: now,
        updatedAt: now,
      );
      
      await setDocument(
        transaction.id,
        newTransaction.toJson(),
      );
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to create transaction ${transaction.id}: ${e.toString()}');
    }
  }

  @override
  Future<TransactionModel?> getTransaction(String transactionId) async {
    try {
      final doc = await getDocument(transactionId);
      if (!doc.exists) return null;
      return TransactionModel.fromJson(doc.data()!);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get transaction $transactionId: ${e.toString()}');
    }
  }

  @override
  Stream<TransactionModel?> watchTransaction(String transactionId) {
    return watchDocument(transactionId).map((doc) {
      if (!doc.exists) return null;
      return TransactionModel.fromJson(doc.data()!);
    });
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      final existing = await getTransaction(transaction.id);
      if (existing == null) {
        throw AppException('Transaction not found: ${transaction.id}');
      }

      final now = DateTime.now();
      final updatedTransaction = transaction.copyWith(
        updatedAt: now,
        version: existing.version + 1,
      );
      
      await updateDocument(transaction.id, updatedTransaction.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update transaction ${transaction.id}: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    try {
      final transaction = await getTransaction(transactionId);
      if (transaction == null) {
        throw AppException('Transaction not found: $transactionId');
      }

      final now = DateTime.now();
      final updatedTransaction = transaction.copyWith(
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
        version: transaction.version + 1,
      );
      
      await updateDocument(transactionId, updatedTransaction.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to delete transaction $transactionId: ${e.toString()}');
    }
  }

  @override
  Future<void> restoreTransaction(String transactionId) async {
    try {
      final transaction = await getTransaction(transactionId);
      if (transaction == null) {
        throw AppException('Transaction not found: $transactionId');
      }

      final now = DateTime.now();
      final updatedTransaction = transaction.copyWith(
        isDeleted: false,
        deletedAt: null,
        updatedAt: now,
        version: transaction.version + 1,
      );
      
      await updateDocument(transactionId, updatedTransaction.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to restore transaction $transactionId: ${e.toString()}');
    }
  }

  @override
  Future<bool> transactionExists(String transactionId) async {
    try {
      return await documentExists(transactionId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to check transaction existence for $transactionId: ${e.toString()}');
    }
  }

  // ==================== Query Methods ====================

  @override
  Future<List<TransactionModel>> getTransactionsByFamily({
    required String familyId,
    bool includeDeleted = false,
    int limit = 100,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildTransactionQuery(
        familyId: familyId,
        includeDeleted: includeDeleted,
      );

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final docs = await query
          .orderBy(FirestoreConstants.transactionDate, descending: true)
          .limit(limit)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get transactions for family $familyId: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByAccount({
    required String accountId,
    required String familyId,
    bool includeDeleted = false,
    int limit = 100,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildTransactionQuery(
        familyId: familyId,
        accountId: accountId,
        includeDeleted: includeDeleted,
      );

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final docs = await query
          .orderBy(FirestoreConstants.transactionDate, descending: true)
          .limit(limit)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get transactions for account $accountId: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory({
    required String categoryId,
    required String familyId,
    bool includeDeleted = false,
    int limit = 100,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildTransactionQuery(
        familyId: familyId,
        categoryId: categoryId,
        includeDeleted: includeDeleted,
      );

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final docs = await query
          .orderBy(FirestoreConstants.transactionDate, descending: true)
          .limit(limit)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get transactions for category $categoryId: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange({
    required String familyId,
    required DateTime startDate,
    required DateTime endDate,
    String? accountId,
    String? categoryId,
    String? type,
    bool includeDeleted = false,
    int limit = 100,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildTransactionQuery(
        familyId: familyId,
        accountId: accountId,
        categoryId: categoryId,
        type: type,
        startDate: startDate,
        endDate: endDate,
        includeDeleted: includeDeleted,
      );

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final docs = await query
          .orderBy(FirestoreConstants.transactionDate, descending: true)
          .limit(limit)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get transactions by date range: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByType({
    required String familyId,
    required String type,
    bool includeDeleted = false,
    int limit = 100,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildTransactionQuery(
        familyId: familyId,
        type: type,
        includeDeleted: includeDeleted,
      );

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final docs = await query
          .orderBy(FirestoreConstants.transactionDate, descending: true)
          .limit(limit)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get transactions by type $type: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getTransactionSummary({
    required String familyId,
    required DateTime startDate,
    required DateTime endDate,
    String? accountId,
  }) async {
    try {
      final transactions = await getTransactionsByDateRange(
        familyId: familyId,
        startDate: startDate,
        endDate: endDate,
        accountId: accountId,
        includeDeleted: false,
      );

      double totalIncome = 0;
      double totalExpense = 0;

      for (final transaction in transactions) {
        if (transaction.type == 'income') {
          totalIncome += transaction.amount;
        } else if (transaction.type == 'expense') {
          totalExpense += transaction.amount;
        }
      }

      return {
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'netAmount': totalIncome - totalExpense,
        'transactionCount': transactions.length,
      };
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get transaction summary: ${e.toString()}');
    }
  }

  @override
  Stream<List<TransactionModel>> watchTransactionsByFamily({
    required String familyId,
    bool includeDeleted = false,
  }) {
    try {
      final query = _buildTransactionQuery(
        familyId: familyId,
        includeDeleted: includeDeleted,
      ).orderBy(FirestoreConstants.transactionDate, descending: true);

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .where((doc) => doc.exists)
            .map((doc) => TransactionModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw AppException('Failed to watch transactions for family $familyId: ${e.toString()}');
    }
  }

  @override
  Stream<List<TransactionModel>> watchTransactionsByAccount({
    required String accountId,
    required String familyId,
    bool includeDeleted = false,
  }) {
    try {
      final query = _buildTransactionQuery(
        familyId: familyId,
        accountId: accountId,
        includeDeleted: includeDeleted,
      ).orderBy(FirestoreConstants.transactionDate, descending: true);

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .where((doc) => doc.exists)
            .map((doc) => TransactionModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw AppException('Failed to watch transactions for account $accountId: ${e.toString()}');
    }
  }

  // ==================== Transaction-Specific Updates ====================

  @override
  Future<void> updateTransactionDescription({
    required String transactionId,
    required String? description,
  }) async {
    await _updateFields(
      transactionId,
      {FirestoreConstants.description: description},
    );
  }

  @override
  Future<void> updateTransactionCategory({
    required String transactionId,
    required String categoryId,
  }) async {
    await _updateFields(
      transactionId,
      {FirestoreConstants.categoryId: categoryId},
    );
  }

  @override
  Future<void> updateTransactionNotes({
    required String transactionId,
    required String? notes,
  }) async {
    await _updateFields(
      transactionId,
      {FirestoreConstants.notes: notes},
    );
  }

  @override
  Future<void> updateTransactionDate({
    required String transactionId,
    required DateTime transactionDate,
  }) async {
    await _updateFields(
      transactionId,
      {FirestoreConstants.transactionDate: transactionDate},
    );
  }

  @override
  Future<void> updateTransactionMetadata({
    required String transactionId,
    required Map<String, dynamic> metadata,
  }) async {
    await _updateFields(
      transactionId,
      {FirestoreConstants.metadata: metadata},
    );
  }
}
