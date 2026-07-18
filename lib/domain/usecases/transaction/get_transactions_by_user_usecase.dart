// lib/domain/usecases/transaction/get_transactions_by_user_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../exceptions/transaction_exceptions.dart';

/// Parameters for [GetTransactionsByUserUseCase].
class GetTransactionsByUserParams extends Equatable {
  final String userId;
  final bool includeArchived;

  const GetTransactionsByUserParams({
    required this.userId,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [userId, includeArchived];
}

/// Use case for getting all transactions belonging to a user.
///
/// This use case handles retrieving all transactions for a specific user
/// with optional filtering for archived transactions.
class GetTransactionsByUserUseCase {
  final TransactionRepository _repository;

  const GetTransactionsByUserUseCase({
    required TransactionRepository repository,
  }) : _repository = repository;

  /// Executes the get transactions by user use case.
  ///
  /// [params] contains the user ID and whether to include archived transactions.
  /// Returns a list of [Transaction]s belonging to the user.
  /// Throws [TransactionException] if validation fails or retrieval fails.
  Future<List<Transaction>> call(GetTransactionsByUserParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const TransactionDataException('User ID cannot be empty.');
    }

    // Delegate to repository with includeArchived flag
    // The repository handles filtering at the data source level
    // This ensures consistent filtering behavior and optimal performance
    return _repository.getTransactionsByUserId(
      params.userId.trim(),
      includeArchived: params.includeArchived,
    );
  }
}
