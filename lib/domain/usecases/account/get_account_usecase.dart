// lib/domain/usecases/account/get_account_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/account.dart';
import '../../repositories/account_repository.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [GetAccountUseCase].
class GetAccountParams extends Equatable {
  final String accountId;

  const GetAccountParams({
    required this.accountId,
  });

  @override
  List<Object?> get props => [accountId];
}

/// Use case for getting a single account by ID.
///
/// This use case handles retrieving a specific account by its ID.
/// It validates the input before delegating to the repository.
class GetAccountUseCase {
  final AccountRepository _repository;

  const GetAccountUseCase({
    required AccountRepository repository,
  }) : _repository = repository;

  /// Executes the get account use case.
  ///
  /// [params] contains the account ID to retrieve.
  /// Returns the [Account] if found.
  /// Throws [AccountException] if validation fails or account not found.
  Future<Account> call(GetAccountParams params) async {
    // Business rule: account ID must not be empty
    if (params.accountId.trim().isEmpty) {
      throw const AccountDataException('Account ID cannot be empty.');
    }

    // Delegate to repository
    return _repository.getAccount(params.accountId);
  }
}
