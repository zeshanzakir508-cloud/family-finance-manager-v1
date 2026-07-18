// lib/domain/usecases/transaction/get_transactions_by_account_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../exceptions/transaction_exceptions.dart';

/// Parameters for [GetTransactionsByAccountUseCase].
class GetTransactionsByAccountParams extends Equatable {
  final String userId;
  final String accountId;
  final bool includeArchived;

  const GetTransactionsByAccountParams({
    required this.userId,
    required this.accountId,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [
        userId,
        accountId,
        includeArchived,
      ];
}

/// Use case for getting transactions by account.
///
/// This use case handles retrieving all transactions for a specific account
/// belonging to a user, with optional filtering for archived transactions.
class GetTransactionsByAccountUseCase {
  final TransactionRepository _repository;

  const GetTransactionsByAccountUseCase({
    required TransactionRepository repository,
  }) : _repository = repository;

  /// Executes the get transactions by account use case.
  ///
  /// [params] contains the user ID, account ID, and whether to include archived transactions.
  /// Returns a list of [Transaction]s belonging to the specified account.
  /// Throws [TransactionException] if validation fails or retrieval fails.
  Future<List<Transaction>> call(GetTransactionsByAccountParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const TransactionDataException('User ID cannot be empty.');
    }

    // Business rule: account ID must not be empty
    if (params.accountId.trim().isEmpty) {
      throw const TransactionDataException('Account ID cannot be empty.');
    }

    // Delegate to repository with account ID and includeArchived flag
    // The repository handles filtering at the data source level
    // This ensures consistent filtering behavior and optimal performance
    return _repository.getTransactionsByAccountId(
      params.userId.trim(),
      params.accountId.trim(),
      includeArchived: params.includeArchived,
    );
  }
}
