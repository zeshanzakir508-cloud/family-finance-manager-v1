// lib/domain/usecases/transaction/get_transactions_by_category_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../exceptions/transaction_exceptions.dart';

/// Parameters for [GetTransactionsByCategoryUseCase].
class GetTransactionsByCategoryParams extends Equatable {
  final String userId;
  final String categoryId;
  final bool includeArchived;

  const GetTransactionsByCategoryParams({
    required this.userId,
    required this.categoryId,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [
        userId,
        categoryId,
        includeArchived,
      ];
}

/// Use case for getting transactions by category.
///
/// This use case handles retrieving all transactions for a specific category
/// belonging to a user, with optional filtering for archived transactions.
class GetTransactionsByCategoryUseCase {
  final TransactionRepository _repository;

  const GetTransactionsByCategoryUseCase({
    required TransactionRepository repository,
  }) : _repository = repository;

  /// Executes the get transactions by category use case.
  ///
  /// [params] contains the user ID, category ID, and whether to include archived transactions.
  /// Returns a list of [Transaction]s belonging to the specified category.
  /// Throws [TransactionException] if validation fails or retrieval fails.
  Future<List<Transaction>> call(GetTransactionsByCategoryParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const TransactionDataException('User ID cannot be empty.');
    }

    // Business rule: category ID must not be empty
    if (params.categoryId.trim().isEmpty) {
      throw const TransactionDataException('Category ID cannot be empty.');
    }

    // Delegate to repository with category ID and includeArchived flag
    // The repository handles filtering at the data source level
    // This ensures consistent filtering behavior and optimal performance
    return _repository.getTransactionsByCategoryId(
      params.userId.trim(),
      params.categoryId.trim(),
      includeArchived: params.includeArchived,
    );
  }
}
