// lib/domain/usecases/transaction/get_monthly_summary_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/monthly_summary.dart';
import '../../repositories/transaction_repository.dart';
import '../../exceptions/transaction_exceptions.dart';

/// Parameters for [GetMonthlySummaryUseCase].
class GetMonthlySummaryParams extends Equatable {
  final String userId;
  final int year;
  final int month;
  final bool includeArchived;

  const GetMonthlySummaryParams({
    required this.userId,
    required this.year,
    required this.month,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [
        userId,
        year,
        month,
        includeArchived,
      ];
}

/// Use case for getting a monthly summary of transactions.
///
/// This use case handles retrieving aggregated transaction data for a user
/// for a specific month. The summary calculation is delegated to the repository
/// for optimal performance and scalability.
class GetMonthlySummaryUseCase {
  final TransactionRepository _repository;

  const GetMonthlySummaryUseCase({
    required TransactionRepository repository,
  }) : _repository = repository;

  /// Executes the get monthly summary use case.
  ///
  /// [params] contains the user ID, year, month, and whether to include archived transactions.
  /// Returns a [MonthlySummary] with aggregated data for the month.
  /// Throws [TransactionException] if validation fails or retrieval fails.
  Future<MonthlySummary> call(GetMonthlySummaryParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const TransactionDataException('User ID cannot be empty.');
    }

    // Business rule: year must be valid
    if (params.year < 2000 || params.year > 2100) {
      throw const TransactionDataException(
        'Year must be between 2000 and 2100.',
      );
    }

    // Business rule: month must be between 1 and 12
    if (params.month < 1 || params.month > 12) {
      throw const TransactionDataException(
        'Month must be between 1 and 12.',
      );
    }

    // Delegate to repository for monthly summary calculation
    // The repository handles:
    // 1. Calculating daily breakdown
    // 2. Calculating income and expense totals
    // 3. Aggregating by category
    // 4. Returning a domain summary object
    return _repository.getMonthlySummary(
      params.userId.trim(),
      params.year,
      params.month,
      includeArchived: params.includeArchived,
    );
  }
}
