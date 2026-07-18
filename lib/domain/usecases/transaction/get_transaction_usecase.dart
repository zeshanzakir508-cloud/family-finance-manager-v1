// lib/domain/usecases/transaction/get_transaction_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../exceptions/transaction_exceptions.dart';

/// Parameters for [GetTransactionUseCase].
class GetTransactionParams extends Equatable {
  final String transactionId;

  const GetTransactionParams({
    required this.transactionId,
  });

  @override
  List<Object?> get props => [transactionId];
}

/// Use case for getting a single transaction by ID.
///
/// This use case handles retrieving a specific transaction by its ID.
/// It validates the input before delegating to the repository.
class GetTransactionUseCase {
  final TransactionRepository _repository;

  const GetTransactionUseCase({
    required TransactionRepository repository,
  }) : _repository = repository;

  /// Executes the get transaction use case.
  ///
  /// [params] contains the transaction ID to retrieve.
  /// Returns the [Transaction] if found.
  /// Throws [TransactionException] if validation fails or transaction not found.
  Future<Transaction> call(GetTransactionParams params) async {
    // Business rule: transaction ID must not be empty
    if (params.transactionId.trim().isEmpty) {
      throw const TransactionDataException('Transaction ID cannot be empty.');
    }

    // Delegate to repository
    return _repository.getTransaction(params.transactionId.trim());
  }
}
