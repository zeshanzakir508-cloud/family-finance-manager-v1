import 'package:flutter/material.dart';
import '../models/account_model.dart';
import '../repositories/account_repository.dart';
import '../validators/account_validator.dart';

/// Business logic controller for account management
class AccountController extends ChangeNotifier {
  final AccountRepository _repository;

  /// List of all accounts
  List<AccountModel> _accounts = [];
  
  /// Currently selected account
  AccountModel? _selectedAccount;
  
  /// Loading state
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;
  
  /// Search query
  String _searchQuery = '';
  
  /// Filter for accounts (all, active, archived)
  String _filter = 'all';

  AccountController(this._repository) {
    initialize();
  }

  // ============ Getters ============
  
  List<AccountModel> get accounts => _accounts;
  AccountModel? get selectedAccount => _selectedAccount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get filter => _filter;
  
  /// Get filtered and searched accounts
  List<AccountModel> get filteredAccounts {
    var filtered = _accounts;
    
    // Apply filter
    if (_filter == 'active') {
      filtered = filtered.where((a) => !a.isArchived).toList();
    } else if (_filter == 'archived') {
      filtered = filtered.where((a) => a.isArchived).toList();
    }
    
    // Apply search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((a) =>
        a.name.toLowerCase().contains(query) ||
        (a.description?.toLowerCase().contains(query) ?? false)
      ).toList();
    }
    
    return filtered;
  }
  
  /// Get active accounts (not archived)
  List<AccountModel> get activeAccounts =>
      _accounts.where((a) => !a.isArchived).toList();
  
  /// Get archived accounts
  List<AccountModel> get archivedAccounts =>
      _accounts.where((a) => a.isArchived).toList();
  
  /// Get total balance of all accounts
  double get totalBalance =>
      _accounts.fold(0.0, (sum, account) => sum + account.currentBalance);
  
  /// Get total balance of active accounts
  double get activeTotalBalance =>
      activeAccounts.fold(0.0, (sum, account) => sum + account.currentBalance);

  // ============ Initialization ============
  
  Future<void> initialize() async {
    try {
      _setLoading(true);
      _clearError();
      await loadAccounts();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize accounts: $e');
      _setLoading(false);
    }
  }

  // ============ Account Loading ============
  
  Future<void> loadAccounts() async {
    try {
      _accounts = await _repository.getAccounts();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load accounts: $e');
      rethrow;
    }
  }

  Future<void> loadAccount(String accountId) async {
    try {
      _selectedAccount = await _repository.getAccount(accountId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load account: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    await loadAccounts();
    if (_selectedAccount != null) {
      await loadAccount(_selectedAccount!.id);
    }
  }

  // ============ Account CRUD Operations ============
  
  Future<void> createAccount({
    required String name,
    String? description,
    required double openingBalance,
    String icon = 'wallet',
    String color = '#4ECDC4',
    String? familyId,
  }) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      final account = await _repository.createAccount(
        name: name,
        description: description,
        openingBalance: openingBalance,
        icon: icon,
        color: color,
        familyId: familyId,
      );

      await loadAccounts();
      _selectedAccount = account;
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create account: $e');
      _setLoading(false);
    }
  }

  Future<void> updateAccount({
    required String accountId,
    String? name,
    String? description,
    double? openingBalance,
    String? icon,
    String? color,
  }) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.updateAccount(
        accountId: accountId,
        name: name,
        description: description,
        openingBalance: openingBalance,
        icon: icon,
        color: color,
      );

      await loadAccounts();
      if (_selectedAccount?.id == accountId) {
        await loadAccount(accountId);
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to update account: $e');
      _setLoading(false);
    }
  }

  Future<void> deleteAccount(String accountId) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.deleteAccount(accountId);
      
      await loadAccounts();
      if (_selectedAccount?.id == accountId) {
        _selectedAccount = null;
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete account: $e');
      _setLoading(false);
    }
  }

  Future<void> archiveAccount(String accountId) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.archiveAccount(accountId);
      
      await loadAccounts();
      if (_selectedAccount?.id == accountId) {
        await loadAccount(accountId);
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to archive account: $e');
      _setLoading(false);
    }
  }

  Future<void> restoreAccount(String accountId) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.restoreAccount(accountId);
      
      await loadAccounts();
      if (_selectedAccount?.id == accountId) {
        await loadAccount(accountId);
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to restore account: $e');
      _setLoading(false);
    }
  }

  // ============ Transfer Operations ============
  
  Future<void> transfer({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    String? note,
    DateTime? date,
  }) async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _clearError();

      await _repository.transfer(
        fromAccountId: fromAccountId,
        toAccountId: toAccountId,
        amount: amount,
        note: note,
        date: date,
      );

      await loadAccounts();
      if (_selectedAccount != null) {
        await loadAccount(_selectedAccount!.id);
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to complete transfer: $e');
      _setLoading(false);
    }
  }

  // ============ Search and Filter ============
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void resetFilter() {
    _filter = 'all';
    notifyListeners();
  }

  // ============ Selection Operations ============
  
  void selectAccount(AccountModel account) {
    _selectedAccount = account;
    notifyListeners();
  }

  void clearSelection() {
    _selectedAccount = null;
    notifyListeners();
  }

  // ============ Utility Methods ============
  
  AccountModel? getAccountById(String id) {
    try {
      return _accounts.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  bool hasAccounts() => _accounts.isNotEmpty;
  
  bool hasActiveAccounts() => activeAccounts.isNotEmpty;
  
  bool hasArchivedAccounts() => archivedAccounts.isNotEmpty;

  int getAccountCount() => _accounts.length;
  
  int getActiveAccountCount() => activeAccounts.length;
  
  int getArchivedAccountCount() => archivedAccounts.length;

  bool isAccountSelected(String id) => _selectedAccount?.id == id;

  // ============ Validation Methods ============
  
  String? validateAccountName(String? name) {
    final result = AccountValidator.validateName(name);
    return result.isValid ? null : result.message;
  }

  String? validateOpeningBalance(String? balance) {
    final result = AccountValidator.validateOpeningBalanceString(balance);
    return result.isValid ? null : result.message;
  }

  String? validateTransferAmount(String? amount) {
    final result = AccountValidator.validateTransferAmountString(amount);
    return result.isValid ? null : result.message;
  }

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
