import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/transaction_controller.dart';
import '../repositories/transaction_repository.dart';
import '../services/transaction_service.dart';
import '../enums/transaction_type.dart';
import '../enums/transaction_status.dart';
import '../enums/transaction_sort.dart';

/// Provider for TransactionService
final transactionServiceProvider = Provider<TransactionService>((ref) {
  throw UnimplementedError('TransactionService must be provided');
});

/// Provider for TransactionRepository
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final service = ref.watch(transactionServiceProvider);
  return TransactionRepository(service);
});

/// Provider for TransactionController
final transactionControllerProvider = Provider<TransactionController>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionController(repository);
});

/// Provider for transaction list
final transactionsProvider = Provider<List<TransactionModel>>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.transactions;
});

/// Provider for filtered transactions
final filteredTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.filteredTransactions;
});

/// Provider for recurring transactions
final recurringTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.recurringTransactions;
});

/// Provider for selected transaction
final selectedTransactionProvider = Provider<TransactionModel?>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.selectedTransaction;
});

/// Provider for total income
final totalIncomeProvider = Provider<double>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.totalIncome;
});

/// Provider for total expenses
final totalExpensesProvider = Provider<double>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.totalExpenses;
});

/// Provider for net income
final netIncomeProvider = Provider<double>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.netIncome;
});

/// Provider for transaction count
final transactionCountProvider = Provider<int>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.getTransactionCount();
});

/// Provider for income count
final incomeCountProvider = Provider<int>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.getIncomeCount();
});

/// Provider for expense count
final expenseCountProvider = Provider<int>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.getExpenseCount();
});

/// Provider for loading state
final transactionsLoadingProvider = Provider<bool>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.isLoading;
});

/// Provider for error message
final transactionsErrorProvider = Provider<String?>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.errorMessage;
});

/// Provider for search query
final transactionSearchQueryProvider = Provider<String>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.searchQuery;
});

/// Provider for filter type
final transactionFilterTypeProvider = Provider<TransactionType?>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.filterType;
});

/// Provider for filter account
final transactionFilterAccountProvider = Provider<String?>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.filterAccountId;
});

/// Provider for filter category
final transactionFilterCategoryProvider = Provider<String?>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.filterCategoryId;
});

/// Provider for filter status
final transactionFilterStatusProvider = Provider<TransactionStatus?>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.filterStatus;
});

/// Provider for sort option
final transactionSortOptionProvider = Provider<TransactionSort>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.sortOption;
});

/// Provider for date range
final transactionDateRangeProvider = Provider<(DateTime?, DateTime?)>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return (controller.startDate, controller.endDate);
});

/// Provider for checking if transactions exist
final hasTransactionsProvider = Provider<bool>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.hasTransactions();
});

/// Provider for getting a transaction by ID
final transactionByIdProvider = Provider.family<TransactionModel?, String>((ref, id) {
  final controller = ref.watch(transactionControllerProvider);
  return controller.getTransactionById(id);
});

/// Provider for transaction actions
final transactionActionsProvider = Provider<TransactionActions>((ref) {
  final controller = ref.watch(transactionControllerProvider);
  return TransactionActions(controller);
});

/// Provider for transaction validator
final transactionValidatorProvider = Provider<TransactionValidator>((ref) {
  return TransactionValidator();
});

/// Provider for transaction summary
final transactionSummaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return await repository.getTransactionSummary();
});

/// Provider for watching transactions
final transactionStreamProvider = StreamProvider<List<TransactionModel>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.watchTransactions();
});

/// Provider for watching transactions by account
final transactionStreamByAccountProvider = StreamProvider.family<List<TransactionModel>, String>((ref, accountId) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.watchTransactions(accountId: accountId);
});

/// Provider for watching transactions by category
final transactionStreamByCategoryProvider = StreamProvider.family<List<TransactionModel>, String>((ref, categoryId) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.watchTransactions(categoryId: categoryId);
});

/// Class containing all transaction actions
class TransactionActions {
  final TransactionController _controller;

  TransactionActions(this._controller);

  /// Create a new transaction
  Future<void> createTransaction({
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
  }) => _controller.createTransaction(
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

  /// Update a transaction
  Future<void> updateTransaction({
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
  }) => _controller.updateTransaction(
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

  /// Delete a transaction
  Future<void> deleteTransaction(String transactionId) => 
      _controller.deleteTransaction(transactionId);

  /// Duplicate a transaction
  Future<void> duplicateTransaction(String transactionId) => 
      _controller.duplicateTransaction(transactionId);

  /// Create a recurring transaction
  Future<void> createRecurringTransaction({
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
  }) => _controller.createRecurringTransaction(
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

  /// Update a recurring transaction
  Future<void> updateRecurringTransaction({
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
  }) => _controller.updateRecurringTransaction(
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

  /// Delete a recurring transaction
  Future<void> deleteRecurringTransaction(String transactionId) => 
      _controller.deleteRecurringTransaction(transactionId);

  /// Set search query
  void setSearchQuery(String query) => _controller.setSearchQuery(query);

  /// Set filter type
  void setFilterType(TransactionType? type) => _controller.setFilterType(type);

  /// Set filter account
  void setFilterAccount(String? accountId) => _controller.setFilterAccount(accountId);

  /// Set filter category
  void setFilterCategory(String? categoryId) => _controller.setFilterCategory(categoryId);

  /// Set filter status
  void setFilterStatus(TransactionStatus? status) => _controller.setFilterStatus(status);

  /// Set sort option
  void setSortOption(TransactionSort sort) => _controller.setSortOption(sort);

  /// Set date range
  void setDateRange(DateTime? start, DateTime? end) => _controller.setDateRange(start, end);

  /// Clear filters
  void clearFilters() => _controller.clearFilters();

  /// Select a transaction
  void selectTransaction(TransactionModel transaction) => _controller.selectTransaction(transaction);

  /// Clear selection
  void clearSelection() => _controller.clearSelection();

  /// Refresh data
  Future<void> refresh() => _controller.refresh();

  /// Load a specific transaction
  Future<void> loadTransaction(String transactionId) => _controller.loadTransaction(transactionId);
}
