import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/account_controller.dart';
import '../repositories/account_repository.dart';
import '../services/account_service.dart';

/// Provider for AccountService
final accountServiceProvider = Provider<AccountService>((ref) {
  throw UnimplementedError('AccountService must be provided');
});

/// Provider for AccountRepository
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final service = ref.watch(accountServiceProvider);
  return AccountRepository(service);
});

/// Provider for AccountController
final accountControllerProvider = Provider<AccountController>((ref) {
  final repository = ref.watch(accountRepositoryProvider);
  return AccountController(repository);
});

/// Provider for account list
final accountsProvider = Provider<List<AccountModel>>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.accounts;
});

/// Provider for filtered accounts
final filteredAccountsProvider = Provider<List<AccountModel>>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.filteredAccounts;
});

/// Provider for active accounts
final activeAccountsProvider = Provider<List<AccountModel>>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.activeAccounts;
});

/// Provider for archived accounts
final archivedAccountsProvider = Provider<List<AccountModel>>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.archivedAccounts;
});

/// Provider for selected account
final selectedAccountProvider = Provider<AccountModel?>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.selectedAccount;
});

/// Provider for total balance
final totalBalanceProvider = Provider<double>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.totalBalance;
});

/// Provider for active total balance
final activeTotalBalanceProvider = Provider<double>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.activeTotalBalance;
});

/// Provider for account count
final accountCountProvider = Provider<int>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.getAccountCount();
});

/// Provider for active account count
final activeAccountCountProvider = Provider<int>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.getActiveAccountCount();
});

/// Provider for archived account count
final archivedAccountCountProvider = Provider<int>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.getArchivedAccountCount();
});

/// Provider for loading state
final accountsLoadingProvider = Provider<bool>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.isLoading;
});

/// Provider for error message
final accountsErrorProvider = Provider<String?>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.errorMessage;
});

/// Provider for search query
final accountSearchQueryProvider = Provider<String>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.searchQuery;
});

/// Provider for filter
final accountFilterProvider = Provider<String>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.filter;
});

/// Provider for checking if accounts exist
final hasAccountsProvider = Provider<bool>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.hasAccounts();
});

/// Provider for checking if active accounts exist
final hasActiveAccountsProvider = Provider<bool>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return controller.hasActiveAccounts();
});

/// Provider for getting an account by ID
final accountByIdProvider = Provider.family<AccountModel?, String>((ref, id) {
  final controller = ref.watch(accountControllerProvider);
  return controller.getAccountById(id);
});

/// Provider for checking if an account is selected
final isAccountSelectedProvider = Provider.family<bool, String>((ref, id) {
  final controller = ref.watch(accountControllerProvider);
  return controller.isAccountSelected(id);
});

/// Provider for account actions
final accountActionsProvider = Provider<AccountActions>((ref) {
  final controller = ref.watch(accountControllerProvider);
  return AccountActions(controller);
});

/// Provider for account validation
final accountValidatorProvider = Provider<AccountValidator>((ref) {
  return AccountValidator();
});

/// Provider for account statistics
final accountStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(accountRepositoryProvider);
  return await repository.getAccountStatistics();
});

/// Provider for watching accounts
final accountStreamProvider = StreamProvider<List<AccountModel>>((ref) {
  final repository = ref.watch(accountRepositoryProvider);
  return repository.watchAccounts();
});

/// Provider for watching accounts by family
final accountStreamByFamilyProvider = StreamProvider.family<List<AccountModel>, String>((ref, familyId) {
  final repository = ref.watch(accountRepositoryProvider);
  return repository.watchAccountsByFamily(familyId);
});

/// Class containing all account actions
class AccountActions {
  final AccountController _controller;

  AccountActions(this._controller);

  /// Create a new account
  Future<void> createAccount({
    required String name,
    String? description,
    required double openingBalance,
    String icon = 'wallet',
    String color = '#4ECDC4',
    String? familyId,
  }) => _controller.createAccount(
    name: name,
    description: description,
    openingBalance: openingBalance,
    icon: icon,
    color: color,
    familyId: familyId,
  );

  /// Update an account
  Future<void> updateAccount({
    required String accountId,
    String? name,
    String? description,
    double? openingBalance,
    String? icon,
    String? color,
  }) => _controller.updateAccount(
    accountId: accountId,
    name: name,
    description: description,
    openingBalance: openingBalance,
    icon: icon,
    color: color,
  );

  /// Delete an account
  Future<void> deleteAccount(String accountId) => 
      _controller.deleteAccount(accountId);

  /// Archive an account
  Future<void> archiveAccount(String accountId) => 
      _controller.archiveAccount(accountId);

  /// Restore an account
  Future<void> restoreAccount(String accountId) => 
      _controller.restoreAccount(accountId);

  /// Transfer between accounts
  Future<void> transfer({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    String? note,
    DateTime? date,
  }) => _controller.transfer(
    fromAccountId: fromAccountId,
    toAccountId: toAccountId,
    amount: amount,
    note: note,
    date: date,
  );

  /// Set search query
  void setSearchQuery(String query) => _controller.setSearchQuery(query);

  /// Set filter
  void setFilter(String filter) => _controller.setFilter(filter);

  /// Clear search
  void clearSearch() => _controller.clearSearch();

  /// Reset filter
  void resetFilter() => _controller.resetFilter();

  /// Select an account
  void selectAccount(AccountModel account) => _controller.selectAccount(account);

  /// Clear selection
  void clearSelection() => _controller.clearSelection();

  /// Refresh data
  Future<void> refresh() => _controller.refresh();

  /// Load a specific account
  Future<void> loadAccount(String accountId) => _controller.loadAccount(accountId);

  /// Validate account name
  String? validateName(String? name) => _controller.validateAccountName(name);

  /// Validate opening balance
  String? validateOpeningBalance(String? balance) => 
      _controller.validateOpeningBalance(balance);

  /// Validate transfer amount
  String? validateTransferAmount(String? amount) => 
      _controller.validateTransferAmount(amount);
}
