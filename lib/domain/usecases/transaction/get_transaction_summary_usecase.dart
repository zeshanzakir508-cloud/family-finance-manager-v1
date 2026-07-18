// lib/domain/usecases/transaction/get_transaction_summary_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/transaction_summary.dart';
import '../../repositories/transaction_repository.dart';
import '../../exceptions/transaction_exceptions.dart';

/// Parameters for [GetTransactionSummaryUseCase].
class GetTransactionSummaryParams extends Equatable {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final bool includeArchived;

  const GetTransactionSummaryParams({
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [
        userId,
        startDate,
        endDate,
        includeArchived,
      ];
}

/// Use case for getting a summary of transactions.
///
/// This use case handles retrieving aggregated transaction data for a user
/// within a date range. The summary calculation is delegated to the repository
/// for optimal performance and scalability.
class GetTransactionSummaryUseCase {
  final TransactionRepository _repository;

  const GetTransactionSummaryUseCase({
    required TransactionRepository repository,
  }) : _repository = repository;

  /// Executes the get transaction summary use case.
  ///
  /// [params] contains the user ID, date range, and whether to include archived transactions.
  /// Returns a [TransactionSummary] with aggregated data.
  /// Throws [TransactionException] if validation fails or retrieval fails.
  Future<TransactionSummary> call(GetTransactionSummaryParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const TransactionDataException('User ID cannot be empty.');
    }

    // Business rule: start date must be before end date
    if (params.startDate.isAfter(params.endDate)) {
      throw const TransactionDataException(
        'Start date must be before end date.',
      );
    }

    // Business rule: date range cannot exceed 1 year
    // This is a business rule to prevent excessive data retrieval
    final daysDifference = params.endDate.difference(params.startDate).inDays;
    if (daysDifference > 365) {
      throw const TransactionDataException(
        'Date range cannot exceed 365 days.',
      );
    }

    // Business rule: start date must be within a reasonable range
    // This ensures we don't query data that doesn't exist in the system
    if (params.startDate.year < 2000) {
      throw const TransactionDataException(
        'Start date cannot be before the year 2000.',
      );
    }

    // Delegate to repository for summary calculation
    // The repository handles:
    // 1. Querying transactions efficiently
    // 2. Calculating income and expense totals
    // 3. Aggregating by category
    // 4. Returning a domain summary object
    return _repository.getTransactionSummary(
      params.userId.trim(),
      params.startDate,
      params.endDate,
      includeArchived: params.includeArchived,
    );
  }
}
