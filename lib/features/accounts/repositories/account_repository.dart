import '../models/account_model.dart';
import '../services/account_service.dart';
import '../validators/account_validator.dart';

/// Repository for account data operations
class AccountRepository {
  final AccountService _service;

  AccountRepository(this._service);

  /// Get all accounts
  Future<List<AccountModel>> getAccounts() async {
    return await _service.getAccounts();
  }

  /// Get accounts by family ID
  Future<List<AccountModel>> getAccountsByFamily(String familyId) async {
    return await _service.getAccountsByFamily(familyId);
  }

  /// Get an account by ID
  Future<AccountModel> getAccount(String accountId) async {
    return await _service.getAccount(accountId);
  }

  /// Create a new account
  Future<AccountModel> createAccount({
    required String name,
    String? description,
    required double openingBalance,
    String icon = 'wallet',
    String color = '#4ECDC4',
    String? familyId,
  }) async {
    // Validate name
    final nameValidation = AccountValidator.validateName(name);
    if (!nameValidation.isValid) {
      throw Exception(nameValidation.message);
    }

    // Validate opening balance
    final balanceValidation = AccountValidator.validateOpeningBalance(openingBalance);
    if (!balanceValidation.isValid) {
      throw Exception(balanceValidation.message);
    }

    // Check for duplicate name
    final existingAccounts = await _service.getAccounts();
    final duplicateValidation = AccountValidator.validateDuplicateName(
      name,
      existingAccounts,
    );
    if (!duplicateValidation.isValid) {
      throw Exception(duplicateValidation.message);
    }

    return await _service.createAccount(
      name: name,
      description: description,
      openingBalance: openingBalance,
      icon: icon,
      color: color,
      familyId: familyId,
    );
  }

  /// Update an existing account
  Future<AccountModel> updateAccount({
    required String accountId,
    String? name,
    String? description,
    double? openingBalance,
    String? icon,
    String? color,
  }) async {
    // Get existing account
    final existingAccount = await _service.getAccount(accountId);

    // Validate name if provided
    if (name != null) {
      final nameValidation = AccountValidator.validateName(name);
      if (!nameValidation.isValid) {
        throw Exception(nameValidation.message);
      }

      // Check for duplicate name
      final existingAccounts = await _service.getAccounts();
      final duplicateValidation = AccountValidator.validateDuplicateName(
        name,
        existingAccounts,
        excludeId: accountId,
      );
      if (!duplicateValidation.isValid) {
        throw Exception(duplicateValidation.message);
      }
    }

    // Validate opening balance if provided
    if (openingBalance != null) {
      final balanceValidation = AccountValidator.validateOpeningBalance(openingBalance);
      if (!balanceValidation.isValid) {
        throw Exception(balanceValidation.message);
      }
    }

    return await _service.updateAccount(
      accountId: accountId,
      name: name,
      description: description,
      openingBalance: openingBalance,
      icon: icon,
      color: color,
    );
  }

  /// Delete an account
  Future<void> deleteAccount(String accountId) async {
    // Get existing account
    final account = await _service.getAccount(accountId);
    
    // Validate deletion
    final validation = AccountValidator.validateDeleteAccount(account);
    if (!validation.isValid) {
      throw Exception(validation.message);
    }

    await _service.deleteAccount(accountId);
  }

  /// Archive an account
  Future<void> archiveAccount(String accountId) async {
    // Get existing account
    final account = await _service.getAccount(accountId);
    
    // Validate archiving
    final validation = AccountValidator.validateArchiveAccount(account);
    if (!validation.isValid) {
      throw Exception(validation.message);
    }

    await _service.archiveAccount(accountId);
  }

  /// Restore an archived account
  Future<void> restoreAccount(String accountId) async {
    // Get existing account
    final account = await _service.getAccount(accountId);
    
    // Validate restoration
    final validation = AccountValidator.validateRestoreAccount(account);
    if (!validation.isValid) {
      throw Exception(validation.message);
    }

    await _service.restoreAccount(accountId);
  }

  /// Transfer amount between accounts
  Future<void> transfer({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    String? note,
    DateTime? date,
  }) async {
    // Validate amount
    final amountValidation = AccountValidator.validateTransferAmount(amount);
    if (!amountValidation.isValid) {
      throw Exception(amountValidation.message);
    }

    // Get accounts
    final fromAccount = await _service.getAccount(fromAccountId);
    final toAccount = await _service.getAccount(toAccountId);

    // Validate accounts
    final accountsValidation = AccountValidator.validateTransferAccounts(
      fromAccount,
      toAccount,
    );
    if (!accountsValidation.isValid) {
      throw Exception(accountsValidation.message);
    }

    // Validate sufficient funds
    final fundsValidation = AccountValidator.validateSufficientFunds(
      fromAccount.currentBalance,
      amount,
    );
    if (!fundsValidation.isValid) {
      throw Exception(fundsValidation.message);
    }

    await _service.transfer(
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      amount: amount,
      note: note,
      date: date,
    );
  }

  /// Search accounts
  Future<List<AccountModel>> searchAccounts(String query) async {
    return await _service.searchAccounts(query);
  }

  /// Filter accounts
  Future<List<AccountModel>> filterAccounts(String filter) async {
    return await _service.filterAccounts(filter);
  }

  /// Get total balance of all accounts
  Future<double> getTotalBalance() async {
    return await _service.getTotalBalance();
  }

  /// Get total balance by family
  Future<double> getTotalBalanceByFamily(String familyId) async {
    return await _service.getTotalBalanceByFamily(familyId);
  }

  /// Get account count
  Future<int> getAccountCount() async {
    return await _service.getAccountCount();
  }

  /// Get active account count
  Future<int> getActiveAccountCount() async {
    return await _service.getActiveAccountCount();
  }

  /// Get archived account count
  Future<int> getArchivedAccountCount() async {
    return await _service.getArchivedAccountCount();
  }

  /// Check if account has transactions
  Future<bool> hasTransactions(String accountId) async {
    return await _service.hasTransactions(accountId);
  }

  /// Get account current balance
  Future<double> getCurrentBalance(String accountId) async {
    return await _service.getCurrentBalance(accountId);
  }

  /// Get accounts with balances
  Future<List<AccountModel>> getAccountsWithBalances() async {
    return await _service.getAccountsWithBalances();
  }

  /// Get account summary
  Future<Map<String, dynamic>> getAccountSummary() async {
    return await _service.getAccountSummary();
  }

  /// Get account by name
  Future<AccountModel?> getAccountByName(String name) async {
    return await _service.getAccountByName(name);
  }

  /// Check if account name exists
  Future<bool> accountNameExists(String name, {String? excludeId}) async {
    return await _service.accountNameExists(name, excludeId: excludeId);
  }

  /// Get recently used accounts
  Future<List<AccountModel>> getRecentAccounts({int limit = 5}) async {
    return await _service.getRecentAccounts(limit: limit);
  }

  /// Get account statistics
  Future<Map<String, dynamic>> getAccountStatistics() async {
    return await _service.getAccountStatistics();
  }

  /// Sync accounts with server
  Future<void> syncAccounts() async {
    await _service.syncAccounts();
  }

  /// Watch accounts changes
  Stream<List<AccountModel>> watchAccounts() {
    return _service.watchAccounts();
  }

  /// Watch accounts changes by family
  Stream<List<AccountModel>> watchAccountsByFamily(String familyId) {
    return _service.watchAccountsByFamily(familyId);
  }

  /// Get accounts by user ID
  Future<List<AccountModel>> getAccountsByUser(String userId) async {
    return await _service.getAccountsByUser(userId);
  }

  /// Get accounts by status
  Future<List<AccountModel>> getAccountsByStatus(bool isArchived) async {
    return await _service.getAccountsByStatus(isArchived);
  }

  /// Get account validation summary
  Future<Map<String, dynamic>> getValidationSummary(String accountId) async {
    final account = await _service.getAccount(accountId);
    return AccountValidator.getValidationSummary(account);
  }
}
