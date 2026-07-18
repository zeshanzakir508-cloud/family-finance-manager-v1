// lib/domain/usecases/transaction/create_recurring_transaction_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/transaction.dart';
import '../../enums/transaction_type.dart';
import '../../enums/recurring_type.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/account_repository.dart';
import '../../exceptions/transaction_exceptions.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [CreateRecurringTransactionUseCase].
class CreateRecurringTransactionParams extends Equatable {
  final String userId;
  final String accountId;
  final String categoryId;
  final double amount;
  final String description;
  final TransactionType type;
  final DateTime startDate;
  final RecurringType recurringType;
  final int recurringInterval;
  final DateTime? endDate;
  final String? familyId;
  final List<String>? tags;
  final String? notes;

  const CreateRecurringTransactionParams({
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.description,
    required this.type,
    required this.startDate,
    required this.recurringType,
    required this.recurringInterval,
    this.endDate,
    this.familyId,
    this.tags,
    this.notes,
  });

  @override
  List<Object?> get props => [
        userId,
        accountId,
        categoryId,
        amount,
        description,
        type,
        startDate,
        recurringType,
        recurringInterval,
        endDate,
        familyId,
        tags,
        notes,
      ];
}

/// Use case for creating a recurring transaction.
///
/// This use case handles creating a transaction that repeats on a regular basis
/// (daily, weekly, monthly, yearly). The repository handles the creation of
/// the initial transaction and the scheduling of future occurrences.
class CreateRecurringTransactionUseCase {
  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;

  const CreateRecurringTransactionUseCase({
    required TransactionRepository transactionRepository,
    required AccountRepository accountRepository,
  })  : _transactionRepository = transactionRepository,
        _accountRepository = accountRepository;

  /// Executes the create recurring transaction use case.
  ///
  /// [params] contains the transaction details and recurrence settings.
  /// Returns the created [Transaction] (initial occurrence).
  /// Throws [TransactionException] or [AccountException] if validation fails.
  Future<Transaction> call(CreateRecurringTransactionParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const TransactionDataException('User ID cannot be empty.');
    }

    // Business rule: account ID must not be empty
    if (params.accountId.trim().isEmpty) {
      throw const TransactionDataException('Account ID cannot be empty.');
    }

    // Business rule: category ID must not be empty
    if (params.categoryId.trim().isEmpty) {
      throw const TransactionDataException('Category ID cannot be empty.');
    }

    // Business rule: amount must be positive
    if (params.amount <= 0) {
      throw const TransactionDataException('Transaction amount must be greater than zero.');
    }

    // Business rule: description must not be empty
    if (params.description.trim().isEmpty) {
      throw const TransactionDataException('Transaction description cannot be empty.');
    }

    // Business rule: description length validation
    if (params.description.trim().length > 500) {
      throw const TransactionDataException('Description must not exceed 500 characters.');
    }

    // Business rule: recurring interval must be positive
    if (params.recurringInterval <= 0) {
      throw const TransactionDataException(
        'Recurring interval must be greater than zero.',
      );
    }

    // Business rule: validate recurring interval based on type
    // This ensures the interval makes sense for the recurrence type
    switch (params.recurringType) {
      case RecurringType.daily:
        if (params.recurringInterval > 365) {
          throw const TransactionDataException(
            'Daily recurring interval cannot exceed 365 days.',
          );
        }
        break;
      case RecurringType.weekly:
        if (params.recurringInterval > 52) {
          throw const TransactionDataException(
            'Weekly recurring interval cannot exceed 52 weeks.',
          );
        }
        break;
      case RecurringType.monthly:
        if (params.recurringInterval > 120) {
          throw const TransactionDataException(
            'Monthly recurring interval cannot exceed 120 months.',
          );
        }
        break;
      case RecurringType.yearly:
        if (params.recurringInterval > 50) {
          throw const TransactionDataException(
            'Yearly recurring interval cannot exceed 50 years.',
          );
        }
        break;
    }

    // Business rule: if endDate is provided, it must be after startDate
    if (params.endDate != null && params.endDate!.isBefore(params.startDate)) {
      throw const TransactionDataException(
        'End date must be after start date.',
      );
    }

    // Business rule: if familyId is provided, it must be valid
    if (params.familyId != null && params.familyId!.trim().isEmpty) {
      throw const TransactionDataException('Family ID cannot be empty if provided.');
    }

    // Get account to validate
    final account = await _accountRepository.getAccount(params.accountId);

    // Business rule: account must belong to the user
    if (account.userId != params.userId) {
      throw const AccountDataException('Account does not belong to this user.');
    }

    // Business rule: account must be active
    if (!account.isActive) {
      throw const AccountDataException(
        'Account is archived. Please restore it first.',
      );
    }

    // Business rule: for expense transactions, check sufficient balance
    if (params.type == TransactionType.expense) {
      if (account.balance < params.amount) {
        throw TransactionDataException(
          'Insufficient balance. Available: ${account.balance.toStringAsFixed(2)}',
        );
      }
    }

    // Delegate to repository
    // The repository handles:
    // 1. Creating the initial transaction with isRecurring flag
    // 2. Storing recurrence settings
    // 3. Updating account balance
    // 4. Scheduling future occurrences
    // 5. All in a single atomic operation
    return _transactionRepository.createRecurringTransaction(
      userId: params.userId.trim(),
      accountId: params.accountId.trim(),
      categoryId: params.categoryId.trim(),
      amount: params.amount,
      description: params.description.trim(),
      type: params.type,
      startDate: params.startDate,
      recurringType: params.recurringType,
      recurringInterval: params.recurringInterval,
      endDate: params.endDate,
      familyId: params.familyId?.trim(),
      tags: params.tags,
      notes: params.notes?.trim(),
    );
  }
}
