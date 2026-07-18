// lib/domain/usecases/account/get_accounts_by_user_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/account.dart';
import '../../repositories/account_repository.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [GetAccountsByUserUseCase].
class GetAccountsByUserParams extends Equatable {
  final String userId;
  final bool includeArchived;

  const GetAccountsByUserParams({
    required this.userId,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [userId, includeArchived];
}

/// Use case for getting all accounts belonging to a user.
///
/// This use case handles retrieving all accounts for a specific user
/// with optional filtering for archived accounts.
class GetAccountsByUserUseCase {
  final AccountRepository _repository;

  const GetAccountsByUserUseCase({
    required AccountRepository repository,
  }) : _repository = repository;

  /// Executes the get accounts by user use case.
  ///
  /// [params] contains the user ID and whether to include archived accounts.
  /// Returns a list of [Account]s belonging to the user.
  /// Throws [AccountException] if validation fails or retrieval fails.
  Future<List<Account>> call(GetAccountsByUserParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const AccountDataException('User ID cannot be empty.');
    }

    // Business rule: delegate to repository with includeArchived flag
    // The repository handles filtering at the data source level
    // This ensures consistent filtering behavior and optimal performance
    return _repository.getAccountsByUserId(
      params.userId,
      includeArchived: params.includeArchived,
    );
  }
}
