// lib/domain/usecases/account/archive_account_usecase.dart

import 'package:equatable/equatable.dart';

import '../../repositories/account_repository.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [ArchiveAccountUseCase].
class ArchiveAccountParams extends Equatable {
  final String accountId;
  final bool archive; // true = archive, false = unarchive

  const ArchiveAccountParams({
    required this.accountId,
    this.archive = true,
  });

  @override
  List<Object?> get props => [accountId, archive];
}

/// Use case for archiving/unarchiving an account.
///
/// This use case handles toggling the active status of an account.
/// Archiving removes the account from active use without deleting it.
/// Unarchiving restores a previously archived account.
class ArchiveAccountUseCase {
  final AccountRepository _repository;

  const ArchiveAccountUseCase({
    required AccountRepository repository,
  }) : _repository = repository;

  /// Executes the archive account use case.
  ///
  /// [params] contains the account ID and archive flag.
  /// Archives or unarchives the account based on the flag.
  /// Throws [AccountException] if validation fails or operation fails.
  Future<void> call(ArchiveAccountParams params) async {
    // Business rule: account ID must not be empty
    if (params.accountId.trim().isEmpty) {
      throw const AccountDataException('Account ID cannot be empty.');
    }

    // Get current account to validate state
    final account = await _repository.getAccount(params.accountId);

    // Business rule: cannot archive if already archived (same state)
    if (params.archive && !account.isActive) {
      throw const AccountDataException('Account is already archived.');
    }

    // Business rule: cannot unarchive if already active
    if (!params.archive && account.isActive) {
      throw const AccountDataException('Account is already active.');
    }

    // Business rule: if archiving, check if account has constraints
    if (params.archive) {
      // Business rule: cannot archive the default account
      if (account.isDefault) {
        throw const AccountDataException(
          'Cannot archive the default account. Please set another account as default first.',
        );
      }

      // Business rule: check if account has a positive balance
      // This is a soft rule - decide if you want to allow archiving with balance
      // For this implementation, we allow archiving with balance
      // but you could add a check here if needed
    }

    // Business rule: if unarchiving, ensure account can be reactivated
    if (!params.archive) {
      // Business rule: check if account name is still valid
      // The account might have been archived for a long time
      // We're not validating this here, but it could be added
    }

    // Business rule: if unarchiving and this is the only account,
    // consider making it default automatically (handled by repository)

    // Delegate to repository
    await _repository.updateAccount(
      account.copyWith(
        isActive: !params.archive,
        // updatedAt will be set by repository/data source
      ),
    );
  }
}
