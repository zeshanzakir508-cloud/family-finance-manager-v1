import '../models/account_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Account Repository
/// ----------------------------------------------------------------------------
/// Defines the contract for managing user accounts.
///
/// Responsibilities:
/// • Create account
/// • Read account(s)
/// • Update account
/// • Soft delete account
/// • Restore account
/// • Watch account changes
///
/// NOTE:
/// This repository ONLY manages account information.
/// It does NOT manage balances or transfers.
///
/// A user's financial balance is calculated from transactions,
/// not stored or maintained in the account.
///
/// Firebase implementation will be provided separately.
/// ============================================================================
abstract class AccountRepository {
  //==========================================================================
  // Account CRUD
  //==========================================================================

  /// Creates a new account.
  Future<void> createAccount(AccountModel account);

  /// Returns an account by its ID.
  Future<AccountModel?> getAccount(String accountId);

  /// Returns all accounts belonging to a family.
  Future<List<AccountModel>> getAccounts(
    String familyId,
  );

  /// Watches an account.
  Stream<AccountModel?> watchAccount(
    String accountId,
  );

  /// Watches all accounts belonging to a family.
  Stream<List<AccountModel>> watchAccounts(
    String familyId,
  );

  /// Updates an existing account.
  Future<void> updateAccount(
    AccountModel account,
  );

  /// Soft deletes an account.
  Future<void> deleteAccount(
    String accountId,
  );

  /// Restores a deleted account.
  Future<void> restoreAccount(
    String accountId,
  );

  /// Returns true if the account exists.
  Future<bool> accountExists(
    String accountId,
  );
}
