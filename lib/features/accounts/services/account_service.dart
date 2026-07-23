import '../models/account_model.dart';

/// Interface for account service operations
abstract class AccountService {
  /// Get all accounts for the current user
  Future<List<AccountModel>> getAccounts();

  /// Get accounts by family ID
  Future<List<AccountModel>> getAccountsByFamily(String familyId);

  /// Get an account by ID
  Future<AccountModel> getAccount(String accountId);

  /// Create a new account
  Future<AccountModel> createAccount({
    required String name,
    String? description,
    required double openingBalance,
    String icon = 'wallet',
    String color = '#4ECDC4',
    String? familyId,
  });

  /// Update an existing account
  Future<AccountModel> updateAccount({
    required String accountId,
    String? name,
    String? description,
    double? openingBalance,
    String? icon,
    String? color,
  });

  /// Delete an account
  Future<void> deleteAccount(String accountId);

  /// Archive an account
  Future<void> archiveAccount(String accountId);

  /// Restore an archived account
  Future<void> restoreAccount(String accountId);

  /// Transfer amount between accounts
  Future<void> transfer({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    String? note,
    DateTime? date,
  });

  /// Get accounts by search query
  Future<List<AccountModel>> searchAccounts(String query);

  /// Get accounts by filter (active/archived/all)
  Future<List<AccountModel>> filterAccounts(String filter);

  /// Get the total balance of all accounts
  Future<double> getTotalBalance();

  /// Get the total balance of accounts by family
  Future<double> getTotalBalanceByFamily(String familyId);

  /// Get account count
  Future<int> getAccountCount();

  /// Get active account count
  Future<int> getActiveAccountCount();

  /// Get archived account count
  Future<int> getArchivedAccountCount();

  /// Check if an account has transactions
  Future<bool> hasTransactions(String accountId);

  /// Get the current balance of an account
  Future<double> getCurrentBalance(String accountId);

  /// Update account balance
  Future<void> updateBalance(String accountId, double newBalance);

  /// Get accounts with balances
  Future<List<AccountModel>> getAccountsWithBalances();

  /// Get account summary
  Future<Map<String, dynamic>> getAccountSummary();

  /// Get accounts by user ID
  Future<List<AccountModel>> getAccountsByUser(String userId);

  /// Get accounts by status
  Future<List<AccountModel>> getAccountsByStatus(bool isArchived);

  /// Get account by name
  Future<AccountModel?> getAccountByName(String name);

  /// Check if account name exists
  Future<bool> accountNameExists(String name, {String? excludeId});

  /// Get recently used accounts
  Future<List<AccountModel>> getRecentAccounts({int limit = 5});

  /// Get account statistics
  Future<Map<String, dynamic>> getAccountStatistics();

  /// Sync accounts with server
  Future<void> syncAccounts();

  /// Listen to account changes
  Stream<List<AccountModel>> watchAccounts();

  /// Listen to account changes by family
  Stream<List<AccountModel>> watchAccountsByFamily(String familyId);
}
