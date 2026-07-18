// lib/domain/usecases/transaction/get_transactions_by_family_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../exceptions/transaction_exceptions.dart';

/// Parameters for [GetTransactionsByFamilyUseCase].
class GetTransactionsByFamilyParams extends Equatable {
  final String familyId;
  final bool includeArchived;

  const GetTransactionsByFamilyParams({
    required this.familyId,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [familyId, includeArchived];
}

/// Use case for getting all transactions belonging to a family.
///
/// This use case handles retrieving all transactions for a specific family
/// with optional filtering for archived transactions.
class GetTransactionsByFamilyUseCase {
  final TransactionRepository _repository;

  const GetTransactionsByFamilyUseCase({
    required TransactionRepository repository,
  }) : _repository = repository;

  /// Executes the get transactions by family use case.
  ///
  /// [params] contains the family ID and whether to include archived transactions.
  /// Returns a list of [Transaction]s belonging to the family.
  /// Throws [TransactionException] if validation fails or retrieval fails.
  Future<List<Transaction>> call(GetTransactionsByFamilyParams params) async {
    // Business rule: family ID must not be empty
    if (params.familyId.trim().isEmpty) {
      throw const TransactionDataException('Family ID cannot be empty.');
    }

    // Delegate to repository with includeArchived flag
    // The repository handles filtering at the data source level
    // This ensures consistent filtering behavior and optimal performance
    return _repository.getTransactionsByFamilyId(
      params.familyId.trim(),
      includeArchived: params.includeArchived,
    );
  }
}
