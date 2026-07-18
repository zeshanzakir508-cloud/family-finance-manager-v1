// lib/domain/usecases/account/delete_account_usecase.dart

import 'package:equatable/equatable.dart';

import '../../repositories/account_repository.dart';
import '../../repositories/transaction_repository.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [DeleteAccountUseCase].
class DeleteAccountParams extends Equatable {
  final String accountId;
  final bool permanent;

  const DeleteAccountParams({
    required this.accountId,
    this.permanent = false,
  });

  @override
  List<Object?> get props => [accountId, permanent];
}

/// Use case for deleting an account.
///
/// This use case handles soft deletion (archiving) or permanent deletion
/// of an account. Soft deletion preserves transaction history while
/// hiding the account from active views.
class DeleteAccountUseCase {
  final AccountRepository _accountRepository;
  final TransactionRepository _transactionRepository;
  final ArchiveAccountUseCase _archiveUseCase;

  const DeleteAccountUseCase({
    required AccountRepository accountRepository,
    required TransactionRepository transactionRepository,
    required ArchiveAccountUseCase archiveUseCase,
  })  : _accountRepository = accountRepository,
        _transactionRepository = transactionRepository,
        _archiveUseCase = archiveUseCase;

  /// Executes the delete account use case.
  ///
  /// [params] contains the account ID and whether deletion should be permanent.
  /// Throws [AccountException] if validation fails or deletion fails.
  Future<void> call(DeleteAccountParams params) async {
    // Business rule: account ID must not be empty
    if (params.accountId.trim().isEmpty) {
      throw const AccountDataException('Account ID cannot be empty.');
    }

    // Get current account to validate state
    final account = await _accountRepository.getAccount(params.accountId);

    // Business rule: cannot delete the default account
    if (account.isDefault) {
      throw const AccountDataException(
        'Cannot delete the default account. Please set another account as default first.',
      );
    }

    // Business rule: check if account has transactions
    final transactions = await _transactionRepository.getTransactionsByAccountId(
      params.accountId,
    );

    if (transactions.isNotEmpty && params.permanent) {
      // Business rule: permanent deletion is not allowed if there are transactions
      throw const AccountDataException(
        'Cannot permanently delete an account with transactions. '
        'Please archive the account instead.',
      );
    }

    // Business rule: if permanent deletion is requested, verify no constraints
    if (params.permanent) {
      // Check if account is referenced elsewhere (e.g., as default in user preferences)
      // This would require checking user preferences - handled by repository

      // Check if account has any active recurring transactions
      // This is handled by repository

      // Permanent deletion - remove the account completely
      await _accountRepository.deleteAccountPermanent(params.accountId);
    } else {
      // Business rule: soft delete - use ArchiveAccountUseCase to archive
      // This avoids duplicating the archiving logic
      await _archiveUseCase(
        ArchiveAccountParams(
          accountId: params.accountId,
          archive: true,
        ),
      );
    }
  }
}
