import 'package:flutter/material.dart';
import '../repositories/transaction_repository.dart';
import '../enums/transaction_type.dart';
import '../enums/transaction_status.dart';
import '../enums/transaction_sort.dart';
import '../enums/recurring_frequency.dart';

/// Business logic controller for transaction management
class TransactionController extends ChangeNotifier {
  final TransactionRepository _repository;

  /// List of all transactions
  List<TransactionModel> _transactions = [];
  
  /// List of recurring transactions
  List<TransactionModel> _recurringTransactions = [];
  
  /// Currently selected transaction
  TransactionModel? _selectedTransaction;
  
  /// Loading state
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;
  
  /// Search query
  String _searchQuery = '';
  
  /// Filter by type
  TransactionType? _filterType;
  
  /// Filter by account
  String? _filterAccountId;
  
  /// Filter by category
  String? _filterCategoryId;
  
  /// Filter by status
  TransactionStatus? _filterStatus;
  
  /// Sort option
  TransactionSort _sortOption = TransactionSort.dateDesc;
  
  /// Date range filter
  DateTime? _startDate;
  DateTime? _endDate;

  TransactionController(this._repository) {
    initialize();
  }

  // ============ Getters ============
  
  List<TransactionModel> get transactions => _transactions;
  List<TransactionModel> get recurringTransactions => _recurringTransactions;
  TransactionModel? get selectedTransaction => _selectedTransaction;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  TransactionType? get filterType => _filterType;
  String? get filterAccountId => _filterAccountId;
  String? get filterCategoryId => _filterCategoryId;
  TransactionStatus? get filterStatus => _filterStatus;
  TransactionSort get sortOption => _sortOption;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  
  /// Get filtered and sorted transactions
  List<TransactionModel> get filteredTransactions {
    var filtered = _transactions;
    
    // Apply search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((t) =>
        t.note?.toLowerCase().contains(query) ?? false ||
        t.categoryName?.toLowerCase().contains(query) ?? false ||
        t.accountName?.toLowerCase().contains(query) ?? false
      ).toList();
    }
    
    // Apply type filter
    if (_filterType != null) {
      filtered = filtered.where((t) => t.type == _filterType).toList();
    }
    
    // Apply account filter
    if (_filterAccountId != null && _filterAccountId!.isNotEmpty) {
      filtered = filtered.where((t) => 
        t.accountId == _filterAccountId || 
        t.fromAccountId == _filterAccountId ||
        t.toAccountId == _filterAccountId
      ).toList();
    }
    
    // Apply category filter
    if (_filterCategoryId != null && _filterCategoryId!.isNotEmpty) {
      filtered = filtered.where((t) => t.categoryId == _filterCategoryId).toList();
    }
    
    // Apply status filter
    if (_filterStatus != null) {
      filtered = filtered.where((t) => t.status == _filterStatus).toList();
    }
    
    // Apply date range
    if (_startDate != null) {
      filtered = filtered.where((t) => t.date.isAfter(_startDate!)).toList();
    }
    if (_endDate != null) {
      filtered = filtered.where((t) => t.date.isBefore(_endDate!)).toList();
    }
    
    // Apply sorting
    filtered.sort((a, b) {
      switch (_sortOption) {
        case TransactionSort.dateDesc:
          return b.date.compareTo(a.date);
        case TransactionSort.dateAsc:
          return a.date.compareTo(b.date);
        case TransactionSort.amountDesc:
          return b.amount.compareTo(a.amount);
        case TransactionSort.amountAsc:
          return a.amount.compareTo(b.amount);
        case TransactionSort.categoryAsc:
          return (a.categoryName ?? '').compareTo(b.categoryName ?? '');
        case TransactionSort.categoryDesc:
          return (b.categoryName ?? '').compareTo(a.categoryName ?? '');
      }
    });
    
    return filtered;
  }
  
  /// Get total income
  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
  
  /// Get total expenses
  double get totalExpenses {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
  
  /// Get net income
  double get netIncome => totalIncome - totalExpenses;

  // ============ Initialization ============
  
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();
      await loadTransactions();
      await loadRecurringTransactions();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize transactions: $e');
      _setLoading(false);
    }
  }

  // ============ Transaction Loading ============
  
  Future<void> loadTransactions() async {
    try {
      _transactions = await _repository.getTransactions();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load transactions: $e');
      rethrow;
    }
  }

  Future<void> loadRecurringTransactions() async {
    try {
      _recurringTransactions = await _repository.getRecurringTransactions();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load recurring transactions: $e');
      rethrow;
    }
  }

  Future<void> loadTransaction(String transactionId) async {
    try {
      _selectedTransaction = await _repository.getTransaction(transactionId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load transaction: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    await loadTransactions();
    await loadRecurringTransactions();
    if (_selectedTransaction != null) {
      await loadTransaction(_selectedTransaction!.id);
    }
  }

  // ============ Transaction CRUD Operations ============
  
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
  }) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      final transaction = await _repository.createTransaction(
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

      await loadTransactions();
      if (isRecurring) {
        await loadRecurringTransactions();
      }
      _selectedTransaction = transaction;
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create transaction: $e');
      _setLoading(false);
    }
  }

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
  }) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.updateTransaction(
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

      await loadTransactions();
      if (_selectedTransaction?.id == transactionId) {
        await loadTransaction(transactionId);
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to update transaction: $e');
      _setLoading(false);
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.deleteTransaction(transactionId);
      
      await loadTransactions();
      if (_selectedTransaction?.id == transactionId) {
        _selectedTransaction = null;
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete transaction: $e');
      _setLoading(false);
    }
  }

  Future<void> duplicateTransaction(String transactionId) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      final transaction = await _repository.duplicateTransaction(transactionId);
      await loadTransactions();
      _selectedTransaction = transaction;
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to duplicate transaction: $e');
      _setLoading(false);
    }
  }

  // ============ Recurring Transaction Operations ============
  
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
  }) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.createRecurringTransaction(
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

      await loadRecurringTransactions();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create recurring transaction: $e');
      _setLoading(false);
    }
  }

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
  }) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.updateRecurringTransaction(
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

      await loadRecurringTransactions();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to update recurring transaction: $e');
      _setLoading(false);
    }
  }

  Future<void> deleteRecurringTransaction(String transactionId) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.deleteRecurringTransaction(transactionId);
      await loadRecurringTransactions();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete recurring transaction: $e');
      _setLoading(false);
    }
  }

  // ============ Filter and Sort ============
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterType(TransactionType? type) {
    _filterType = type;
    notifyListeners();
  }

  void setFilterAccount(String? accountId) {
    _filterAccountId = accountId;
    notifyListeners();
  }

  void setFilterCategory(String? categoryId) {
    _filterCategoryId = categoryId;
    notifyListeners();
  }

  void setFilterStatus(TransactionStatus? status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setSortOption(TransactionSort sort) {
    _sortOption = sort;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterType = null;
    _filterAccountId = null;
    _filterCategoryId = null;
    _filterStatus = null;
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  // ============ Selection Operations ============
  
  void selectTransaction(TransactionModel transaction) {
    _selectedTransaction = transaction;
    notifyListeners();
  }

  void clearSelection() {
    _selectedTransaction = null;
    notifyListeners();
  }

  // ============ Utility Methods ============
  
  TransactionModel? getTransactionById(String id) {
    try {
      return _transactions.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  bool hasTransactions() => _transactions.isNotEmpty;

  int getTransactionCount() => _transactions.length;
  
  int getIncomeCount() => _transactions.where((t) => t.type == TransactionType.income).length;
  
  int getExpenseCount() => _transactions.where((t) => t.type == TransactionType.expense).length;

  // ============ Private Helpers ============
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
