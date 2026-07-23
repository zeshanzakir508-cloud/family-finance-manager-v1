import '../enums/transaction_type.dart';
import '../enums/transaction_status.dart';
import '../enums/recurring_frequency.dart';

/// Interface for transaction service operations
abstract class TransactionService {
  /// Get all transactions for the current user/family
  Future<List<TransactionModel>> getTransactions({
    String? accountId,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? searchQuery,
    int? limit,
  });

  /// Get transactions for a specific account
  Future<List<TransactionModel>> getTransactionsByAccount(String accountId);

  /// Get transactions for a specific category
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId);

  /// Get a transaction by ID
  Future<TransactionModel> getTransaction(String transactionId);

  /// Create a new transaction
  Future<TransactionModel> createTransaction({
    required double amount,
    required DateTime date,
    required TransactionType type,
    required String accountId,
    String? categoryId,
    String? fromAccountId,
    String? toAccountId,
    String? note,
    TransactionStatus status = TransactionStatus.completed,
    bool isRecurring = false,
    RecurringFrequency? frequency,
    DateTime? recurringEndDate,
    String? familyId,
  });

  /// Update an existing transaction
  Future<TransactionModel> updateTransaction({
    required String transactionId,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? accountId,
    String? categoryId,
    String? fromAccountId,
    String? toAccountId,
    String? note,
    TransactionStatus? status,
  });

  /// Delete a transaction
  Future<void> deleteTransaction(String transactionId);

  /// Duplicate a transaction
  Future<TransactionModel> duplicateTransaction(String transactionId);

  /// Get recurring transactions
  Future<List<TransactionModel>> getRecurringTransactions();

  /// Create a recurring transaction
  Future<TransactionModel> createRecurringTransaction({
    required double amount,
    required DateTime date,
    required TransactionType type,
    required String accountId,
    String? categoryId,
    String? fromAccountId,
    String? toAccountId,
    String? note,
    required RecurringFrequency frequency,
    DateTime? endDate,
    String? familyId,
  });

  /// Update a recurring transaction
  Future<TransactionModel> updateRecurringTransaction({
    required String transactionId,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? accountId,
    String? categoryId,
    String? fromAccountId,
    String? toAccountId,
    String? note,
    RecurringFrequency? frequency,
    DateTime? endDate,
    bool? isActive,
  });

  /// Delete a recurring transaction
  Future<void> deleteRecurringTransaction(String transactionId);

  /// Get transaction summary
  Future<Map<String, dynamic>> getTransactionSummary({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get transaction statistics
  Future<Map<String, dynamic>> getTransactionStatistics();

  /// Sync transactions with server
  Future<void> syncTransactions();

  /// Listen to transaction changes
  Stream<List<TransactionModel>> watchTransactions({
    String? accountId,
    String? categoryId,
  });

  /// Listen to recurring transaction changes
  Stream<List<TransactionModel>> watchRecurringTransactions();

  /// Get transactions by date range
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get transactions by status
  Future<List<TransactionModel>> getTransactionsByStatus(TransactionStatus status);

  /// Check if a transaction exists
  Future<bool> transactionExists(String transactionId);

  /// Get recent transactions
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10});

  /// Get transactions for transfer between accounts
  Future<List<TransactionModel>> getTransferTransactions(String accountId);

  /// Get total income for a period
  Future<double> getTotalIncome(DateTime startDate, DateTime endDate);

  /// Get total expenses for a period
  Future<double> getTotalExpenses(DateTime startDate, DateTime endDate);

  /// Get net income for a period
  Future<double> getNetIncome(DateTime startDate, DateTime endDate);

  /// Get transactions by recurring status
  Future<List<TransactionModel>> getTransactionsByRecurring(bool isRecurring);
}
