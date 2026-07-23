import '../services/transaction_service.dart';
import '../validators/transaction_validator.dart';
import '../enums/transaction_type.dart';
import '../enums/transaction_status.dart';
import '../enums/recurring_frequency.dart';

/// Repository for transaction data operations
class TransactionRepository {
  final TransactionService _service;

  TransactionRepository(this._service);

  /// Get all transactions with filters
  Future<List<TransactionModel>> getTransactions({
    String? accountId,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? searchQuery,
    int? limit,
  }) async {
    return await _service.getTransactions(
      accountId: accountId,
      categoryId: categoryId,
      startDate: startDate,
      endDate: endDate,
      type: type,
      searchQuery: searchQuery,
      limit: limit,
    );
  }

  /// Get transactions by account
  Future<List<TransactionModel>> getTransactionsByAccount(String accountId) async {
    return await _service.getTransactionsByAccount(accountId);
  }

  /// Get transactions by category
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId) async {
    return await _service.getTransactionsByCategory(categoryId);
  }

  /// Get a transaction by ID
  Future<TransactionModel> getTransaction(String transactionId) async {
    return await _service.getTransaction(transactionId);
  }

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
  }) async {
    // Validate amount
    final amountValidation = TransactionValidator.validateAmount(amount);
    if (!amountValidation.isValid) {
      throw Exception(amountValidation.message);
    }

    // Validate date
    final dateValidation = TransactionValidator.validateDate(date);
    if (!dateValidation.isValid) {
      throw Exception(dateValidation.message);
    }

    // Validate type
    final typeValidation = TransactionValidator.validateType(type);
    if (!typeValidation.isValid) {
      throw Exception(typeValidation.message);
    }

    // Validate account based on type
    if (type == TransactionType.transfer) {
      final transferValidation = TransactionValidator.validateTransferAccounts(
        fromAccountId,
        toAccountId,
      );
      if (!transferValidation.isValid) {
        throw Exception(transferValidation.message);
      }
    } else {
      final accountValidation = TransactionValidator.validateAccount(accountId);
      if (!accountValidation.isValid) {
        throw Exception(accountValidation.message);
      }
      // Validate category for non-transfer transactions
      final categoryValidation = TransactionValidator.validateCategoryForType(
        categoryId,
        type,
      );
      if (!categoryValidation.isValid) {
        throw Exception(categoryValidation.message);
      }
    }

    // Validate note
    final noteValidation = TransactionValidator.validateNote(note);
    if (!noteValidation.isValid) {
      throw Exception(noteValidation.message);
    }

    // Validate recurring
    final recurringValidation = TransactionValidator.validateRecurring(
      isRecurring: isRecurring,
      endDate: recurringEndDate,
      frequency: frequency?.occurrencesPerYear,
    );
    if (!recurringValidation.isValid) {
      throw Exception(recurringValidation.message);
    }

    return await _service.createTransaction(
      amount: amount,
      date: date,
      type: type,
      accountId: accountId,
      categoryId: categoryId,
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      note: note,
      status: status,
      isRecurring: isRecurring,
      frequency: frequency,
      recurringEndDate: recurringEndDate,
      familyId: familyId,
    );
  }

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
  }) async {
    // Get existing transaction
    final existing = await _service.getTransaction(transactionId);

    // Validate amount if provided
    if (amount != null) {
      final amountValidation = TransactionValidator.validateAmount(amount);
      if (!amountValidation.isValid) {
        throw Exception(amountValidation.message);
      }
    }

    // Validate date if provided
    if (date != null) {
      final dateValidation = TransactionValidator.validateDate(date);
      if (!dateValidation.isValid) {
        throw Exception(dateValidation.message);
      }
    }

    // Validate note if provided
    if (note != null) {
      final noteValidation = TransactionValidator.validateNote(note);
      if (!noteValidation.isValid) {
        throw Exception(noteValidation.message);
      }
    }

    // Validate type if provided
    final effectiveType = type ?? existing.type;
    final effectiveAccountId = accountId ?? existing.accountId;
    final effectiveCategoryId = categoryId ?? existing.categoryId;
    final effectiveFromAccountId = fromAccountId ?? existing.fromAccountId;
    final effectiveToAccountId = toAccountId ?? existing.toAccountId;

    if (effectiveType == TransactionType.transfer) {
      final transferValidation = TransactionValidator.validateTransferAccounts(
        effectiveFromAccountId,
        effectiveToAccountId,
      );
      if (!transferValidation.isValid) {
        throw Exception(transferValidation.message);
      }
    } else {
      final accountValidation = TransactionValidator.validateAccount(effectiveAccountId);
      if (!accountValidation.isValid) {
        throw Exception(accountValidation.message);
      }
      final categoryValidation = TransactionValidator.validateCategoryForType(
        effectiveCategoryId,
        effectiveType,
      );
      if (!categoryValidation.isValid) {
        throw Exception(categoryValidation.message);
      }
    }

    return await _service.updateTransaction(
      transactionId: transactionId,
      amount: amount,
      date: date,
      type: type,
      accountId: accountId,
      categoryId: categoryId,
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      note: note,
      status: status,
    );
  }

  /// Delete a transaction
  Future<void> deleteTransaction(String transactionId) async {
    await _service.deleteTransaction(transactionId);
  }

  /// Duplicate a transaction
  Future<TransactionModel> duplicateTransaction(String transactionId) async {
    return await _service.duplicateTransaction(transactionId);
  }

  /// Get recurring transactions
  Future<List<TransactionModel>> getRecurringTransactions() async {
    return await _service.getRecurringTransactions();
  }

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
  }) async {
    // Validate recurring
    final recurringValidation = TransactionValidator.validateRecurring(
      isRecurring: true,
      endDate: endDate,
      frequency: frequency.occurrencesPerYear,
    );
    if (!recurringValidation.isValid) {
      throw Exception(recurringValidation.message);
    }

    return await _service.createRecurringTransaction(
      amount: amount,
      date: date,
      type: type,
      accountId: accountId,
      categoryId: categoryId,
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      note: note,
      frequency: frequency,
      endDate: endDate,
      familyId: familyId,
    );
  }

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
  }) async {
    return await _service.updateRecurringTransaction(
      transactionId: transactionId,
      amount: amount,
      date: date,
      type: type,
      accountId: accountId,
      categoryId: categoryId,
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      note: note,
      frequency: frequency,
      endDate: endDate,
      isActive: isActive,
    );
  }

  /// Delete a recurring transaction
  Future<void> deleteRecurringTransaction(String transactionId) async {
    await _service.deleteRecurringTransaction(transactionId);
  }

  /// Get transaction summary
  Future<Map<String, dynamic>> getTransactionSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _service.getTransactionSummary(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Get transaction statistics
  Future<Map<String, dynamic>> getTransactionStatistics() async {
    return await _service.getTransactionStatistics();
  }

  /// Sync transactions with server
  Future<void> syncTransactions() async {
    await _service.syncTransactions();
  }

  /// Watch transactions changes
  Stream<List<TransactionModel>> watchTransactions({
    String? accountId,
    String? categoryId,
  }) {
    return _service.watchTransactions(
      accountId: accountId,
      categoryId: categoryId,
    );
  }

  /// Watch recurring transactions changes
  Stream<List<TransactionModel>> watchRecurringTransactions() {
    return _service.watchRecurringTransactions();
  }

  /// Get transactions by date range
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _service.getTransactionsByDateRange(startDate, endDate);
  }

  /// Get transactions by status
  Future<List<TransactionModel>> getTransactionsByStatus(TransactionStatus status) async {
    return await _service.getTransactionsByStatus(status);
  }

  /// Check if a transaction exists
  Future<bool> transactionExists(String transactionId) async {
    return await _service.transactionExists(transactionId);
  }

  /// Get recent transactions
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10}) async {
    return await _service.getRecentTransactions(limit: limit);
  }

  /// Get transfer transactions for an account
  Future<List<TransactionModel>> getTransferTransactions(String accountId) async {
    return await _service.getTransferTransactions(accountId);
  }

  /// Get total income for a period
  Future<double> getTotalIncome(DateTime startDate, DateTime endDate) async {
    return await _service.getTotalIncome(startDate, endDate);
  }

  /// Get total expenses for a period
  Future<double> getTotalExpenses(DateTime startDate, DateTime endDate) async {
    return await _service.getTotalExpenses(startDate, endDate);
  }

  /// Get net income for a period
  Future<double> getNetIncome(DateTime startDate, DateTime endDate) async {
    return await _service.getNetIncome(startDate, endDate);
  }

  /// Get transactions by recurring status
  Future<List<TransactionModel>> getTransactionsByRecurring(bool isRecurring) async {
    return await _service.getTransactionsByRecurring(isRecurring);
  }
}
