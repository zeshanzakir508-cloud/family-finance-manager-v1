import '../models/account_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Account Repository
/// ----------------------------------------------------------------------------
/// Defines the contract for managing financial accounts.
///
/// Responsibilities:
/// • Create account
/// • Read account(s)
/// • Update account
/// • Soft delete account
/// • Restore account
/// • Watch account changes
/// • Manage account balances
/// • Handle account-to-account transfers
///
/// NOTE:
/// This file only defines the repository contract.
/// Firebase implementation will be provided later.
/// ============================================================================

abstract class AccountRepository {
  //==========================================================================
  // Account
  //==========================================================================

  /// Creates a new account.
  Future<void> createAccount(AccountModel account);

  /// Returns an account by its ID.
  Future<AccountModel?> getAccount(String accountId);

  /// Returns all accounts belonging to a family.
  Future<List<AccountModel>> getAccounts(String familyId);

  /// Watches an account.
  Stream<AccountModel?> watchAccount(String accountId);

  /// Watches all accounts of a family.
  Stream<List<AccountModel>> watchAccounts(String familyId);

  /// Updates an existing account.
  Future<void> updateAccount(AccountModel account);

  /// Soft deletes an account.
  Future<void> deleteAccount(String accountId);

  /// Restores a deleted account.
  Future<void> restoreAccount(String accountId);

  /// Returns true if the account exists.
  Future<bool> accountExists(String accountId);

  //==========================================================================
  // Balance
  //==========================================================================

  /// Returns the latest account balance.
  Future<double> getBalance(String accountId);

  /// Updates the account balance.
  Future<void> updateBalance({
    required String accountId,
    required double balance,
  });

  /// Adjusts the account balance by an amount.
  ///
  /// Positive amount increases balance.
  /// Negative amount decreases balance.
  Future<void> adjustBalance({
    required String accountId,
    required double amount,
  });

  //==========================================================================
  // Transfer
  //==========================================================================

  /// Transfers funds between two accounts.
  ///
  /// The implementation must ensure the transfer is atomic.
  Future<void> transfer({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
  });
}
