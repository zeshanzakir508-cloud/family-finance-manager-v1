// lib/domain/usecases/transaction/get_transactions_by_date_range_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../exceptions/transaction_exceptions.dart';

/// Parameters for [GetTransactionsByDateRangeUseCase].
class GetTransactionsByDateRangeParams extends Equatable {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final bool includeArchived;

  const GetTransactionsByDateRangeParams({
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

/// Use case for getting transactions within a date range.
///
/// This use case handles retrieving all transactions for a user within a
/// specific date range, with optional filtering for archived transactions.
class GetTransactionsByDateRangeUseCase {
  final TransactionRepository _repository;

  const GetTransactionsByDateRangeUseCase({
    required TransactionRepository repository,
  }) : _repository = repository;

  /// Executes the get transactions by date range use case.
  ///
  /// [params] contains the user ID, start date, end date, and whether to include archived transactions.
  /// Returns a list of [Transaction]s within the date range.
  /// Throws [TransactionException] if validation fails or retrieval fails.
  Future<List<Transaction>> call(GetTransactionsByDateRangeParams params) async {
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

    // Delegate to repository with date range and includeArchived flag
    // The repository handles filtering at the data source level
    // This ensures consistent filtering behavior and optimal performance
    return _repository.getTransactionsByDateRange(
      params.userId.trim(),
      params.startDate,
      params.endDate,
      includeArchived: params.includeArchived,
    );
  }
}
