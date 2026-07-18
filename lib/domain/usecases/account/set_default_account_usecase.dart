// lib/domain/usecases/account/set_default_account_usecase.dart

import 'package:equatable/equatable.dart';

import '../../repositories/account_repository.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [SetDefaultAccountUseCase].
class SetDefaultAccountParams extends Equatable {
  final String userId;
  final String accountId;

  const SetDefaultAccountParams({
    required this.userId,
    required this.accountId,
  });

  @override
  List<Object?> get props => [userId, accountId];
}

/// Use case for setting a default account for a user.
///
/// This use case handles setting a specific account as the default
/// for a user. It validates the account exists, is active, and belongs
/// to the user before delegating to the repository.
class SetDefaultAccountUseCase {
  final AccountRepository _repository;

  const SetDefaultAccountUseCase({
    required AccountRepository repository,
  }) : _repository = repository;

  /// Executes the set default account use case.
  ///
  /// [params] contains the user ID and the account ID to set as default.
  /// Returns the updated [Account] if successful.
  /// Throws [AccountException] if validation fails or operation fails.
  Future<Account> call(SetDefaultAccountParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const AccountDataException('User ID cannot be empty.');
    }

    // Business rule: account ID must not be empty
    if (params.accountId.trim().isEmpty) {
      throw const AccountDataException('Account ID cannot be empty.');
    }

    // Get the account to validate it exists and belongs to the user
    final account = await _repository.getAccount(params.accountId);

    // Business rule: account must belong to the user
    if (account.userId != params.userId) {
      throw const AccountDataException('Account does not belong to this user.');
    }

    // Business rule: account must be active (not archived)
    if (!account.isActive) {
      throw const AccountDataException(
        'Cannot set an archived account as default. Please restore the account first.',
      );
    }

    // Business rule: account must have a valid balance
    // This is a soft rule - we allow setting as default even with zero balance
    // but we could add a warning if needed

    // Business rule: if account is already default, this is a no-op
    if (account.isDefault) {
      // Account is already the default, return it
      return account;
    }

    // Delegate to repository - the repository will handle:
    // 1. Clearing the current default account for this user
    // 2. Setting the new account as default
    // 3. Updating timestamps
    return _repository.setDefaultAccount(params.userId, params.accountId);
  }
}
