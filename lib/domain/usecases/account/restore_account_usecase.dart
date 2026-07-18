// lib/domain/usecases/account/restore_account_usecase.dart

import 'package:equatable/equatable.dart';

import '../../repositories/account_repository.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [RestoreAccountUseCase].
class RestoreAccountParams extends Equatable {
  final String accountId;

  const RestoreAccountParams({
    required this.accountId,
  });

  @override
  List<Object?> get props => [accountId];
}

/// Use case for restoring an archived account.
///
/// This use case handles reactivating an archived account, making it
/// visible and usable again. It validates that the account is archived
/// and can be restored.
class RestoreAccountUseCase {
  final AccountRepository _repository;

  const RestoreAccountUseCase({
    required AccountRepository repository,
  }) : _repository = repository;

  /// Executes the restore account use case.
  ///
  /// [params] contains the account ID to restore.
  /// Returns the restored [Account] if successful.
  /// Throws [AccountException] if validation fails or restore fails.
  Future<Account> call(RestoreAccountParams params) async {
    // Business rule: account ID must not be empty
    if (params.accountId.trim().isEmpty) {
      throw const AccountDataException('Account ID cannot be empty.');
    }

    // Get current account to validate state
    final account = await _repository.getAccount(params.accountId);

    // Business rule: account must be archived (inactive) to restore
    if (account.isActive) {
      throw const AccountDataException('Account is already active.');
    }

    // Business rule: account must have a valid name
    if (account.name.trim().isEmpty) {
      throw const AccountDataException('Cannot restore account with empty name.');
    }

    // Business rule: account must have a valid type
    const validTypes = ['bank', 'cash', 'credit_card', 'investment', 'savings', 'other'];
    if (!validTypes.contains(account.type.trim().toLowerCase())) {
      throw const AccountDataException('Cannot restore account with invalid type.');
    }

    // Business rule: account must have a valid currency
    if (account.currency.trim().length != 3) {
      throw const AccountDataException('Cannot restore account with invalid currency.');
    }

    // Restore the account (set isActive to true)
    final restoredAccount = account.copyWith(
      isActive: true,
    );

    // Delegate to repository
    return _repository.updateAccount(restoredAccount);
  }
}
