import '../models/transaction_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Transaction Repository
/// ----------------------------------------------------------------------------
/// Defines the contract for managing financial transactions.
///
/// Responsibilities:
/// • Create transaction
/// • Read transaction(s)
/// • Update transaction
/// • Soft delete transaction
/// • Restore transaction
/// • Watch transaction changes
/// • Search transactions
/// • Filter transactions
/// • Account statements
/// • Reporting support
///
/// NOTE:
/// This file only defines the repository contract.
/// Firebase implementation will be provided later.
/// ============================================================================

abstract class TransactionRepository {
  //==========================================================================
  // Transaction
  //==========================================================================

  /// Creates a new transaction.
  Future<void> createTransaction(TransactionModel transaction);

  /// Returns a transaction by its ID.
  Future<TransactionModel?> getTransaction(String transactionId);

  /// Returns all transactions belonging to a family.
  Future<List<TransactionModel>> getTransactions(
    String familyId,
  );

  /// Watches a single transaction.
  Stream<TransactionModel?> watchTransaction(
    String transactionId,
  );

  /// Watches all family transactions.
  Stream<List<TransactionModel>> watchTransactions(
    String familyId,
  );

  /// Updates an existing transaction.
  Future<void> updateTransaction(
    TransactionModel transaction,
  );

  /// Soft deletes a transaction.
  Future<void> deleteTransaction(
    String transactionId,
  );

  /// Restores a deleted transaction.
  Future<void> restoreTransaction(
    String transactionId,
  );

  /// Returns true if the transaction exists.
  Future<bool> transactionExists(
    String transactionId,
  );

  //==========================================================================
  // Date Filters
  //==========================================================================

  /// Returns transactions within the specified date range.
  Future<List<TransactionModel>> getTransactionsByDateRange({
    required String familyId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Watches transactions within the specified date range.
  Stream<List<TransactionModel>> watchTransactionsByDateRange({
    required String familyId,
    required DateTime startDate,
    required DateTime endDate,
  });

  //==========================================================================
  // Account Filters
  //==========================================================================

  /// Returns all transactions for an account.
  Future<List<TransactionModel>> getTransactionsByAccount({
    required String familyId,
    required String accountId,
  });

  /// Watches all transactions for an account.
  Stream<List<TransactionModel>> watchTransactionsByAccount({
    required String familyId,
    required String accountId,
  });

  //==========================================================================
  // Category Filters
  //==========================================================================

  /// Returns all transactions for a category.
  Future<List<TransactionModel>> getTransactionsByCategory({
    required String familyId,
    required String categoryId,
  });

  /// Watches all transactions for a category.
  Stream<List<TransactionModel>> watchTransactionsByCategory({
    required String familyId,
    required String categoryId,
  });

  //==========================================================================
  // Search
  //==========================================================================

  /// Searches transactions by keyword.
  Future<List<TransactionModel>> searchTransactions({
    required String familyId,
    required String keyword,
  });

  //==========================================================================
  // Reports
  //==========================================================================

  /// Returns all transactions used for reporting.
  Future<List<TransactionModel>> getReportTransactions({
    required String familyId,
    required DateTime startDate,
    required DateTime endDate,
  });
}
