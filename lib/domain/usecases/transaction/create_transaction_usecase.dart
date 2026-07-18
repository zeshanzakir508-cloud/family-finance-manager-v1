// lib/domain/usecases/transaction/create_transaction_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/transaction.dart';
import '../../entities/split_transaction.dart';
import '../../enums/transaction_type.dart';
import '../../enums/recurring_type.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/account_repository.dart';
import '../../exceptions/transaction_exceptions.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [CreateTransactionUseCase].
class CreateTransactionParams extends Equatable {
  final String userId;
  final String accountId;
  final String categoryId;
  final double amount;
  final String description;
  final TransactionType type;
  final DateTime date;
  final String? familyId;
  final bool isRecurring;
  final RecurringType? recurringType;
  final int? recurringInterval;
  final bool isSplit;
  final List<SplitTransaction>? splitTransactions;
  final List<String>? attachments;
  final List<String>? tags;
  final String? notes;
  final String? location;

  const CreateTransactionParams({
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.description,
    required this.type,
    required this.date,
    this.familyId,
    this.isRecurring = false,
    this.recurringType,
    this.recurringInterval,
    this.isSplit = false,
    this.splitTransactions,
    this.attachments,
    this.tags,
    this.notes,
    this.location,
  });

  @override
  List<Object?> get props => [
        userId,
        accountId,
        categoryId,
        amount,
        description,
        type,
        date,
        familyId,
        isRecurring,
        recurringType,
        recurringInterval,
        isSplit,
        splitTransactions,
        attachments,
        tags,
        notes,
        location,
      ];
}

/// Use case for creating a new transaction.
///
/// This use case handles creating a new financial transaction with validation
/// and business rules before delegating to the repository.
class CreateTransactionUseCase {
  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;

  const CreateTransactionUseCase({
    required TransactionRepository transactionRepository,
    required AccountRepository accountRepository,
  })  : _transactionRepository = transactionRepository,
        _accountRepository = accountRepository;

  /// Executes the create transaction use case.
  ///
  /// [params] contains the transaction details for creation.
  /// Returns the created [Transaction] if successful.
  /// Throws [TransactionException] or [AccountException] if validation fails or creation fails.
  Future<Transaction> call(CreateTransactionParams params) async {
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

    // Business rule: max amount validation
    const maxAmount = 999999999.99;
    if (params.amount > maxAmount) {
      throw TransactionDataException(
        'Transaction amount exceeds maximum allowed (${maxAmount.toStringAsFixed(2)}).',
      );
    }

    // Business rule: description must not be empty
    if (params.description.trim().isEmpty) {
      throw const TransactionDataException('Transaction description cannot be empty.');
    }

    // Business rule: description length validation
    if (params.description.trim().length > 500) {
      throw const TransactionDataException('Description must not exceed 500 characters.');
    }

    // Business rule: if familyId is provided, it must be valid
    if (params.familyId != null && params.familyId!.trim().isEmpty) {
      throw const TransactionDataException('Family ID cannot be empty if provided.');
    }

    // Business rule: if isRecurring is true, recurringType and recurringInterval must be provided
    if (params.isRecurring) {
      if (params.recurringType == null) {
        throw const TransactionDataException(
          'Recurring type is required for recurring transactions.',
        );
      }
      if (params.recurringInterval == null || params.recurringInterval! <= 0) {
        throw const TransactionDataException(
          'Recurring interval must be greater than zero.',
        );
      }
    }

    // Business rule: if isSplit is true, splitTransactions must be provided
    if (params.isSplit) {
      if (params.splitTransactions == null || params.splitTransactions!.isEmpty) {
        throw const TransactionDataException(
          'Split transactions are required for split transactions.',
        );
      }
      // Validate split transactions sum equals total amount
      final splitSum = params.splitTransactions!.fold<double>(
        0.0,
        (sum, split) => sum + split.amount,
      );
      if ((splitSum - params.amount).abs() > 0.001) {
        throw TransactionDataException(
          'Split transactions sum (${splitSum.toStringAsFixed(2)}) does not match total amount (${params.amount.toStringAsFixed(2)}).',
        );
      }
      // Validate each split
      for (final split in params.splitTransactions!) {
        if (split.categoryId.trim().isEmpty) {
          throw const TransactionDataException(
            'Each split transaction must have a category ID.',
          );
        }
        if (split.amount <= 0) {
          throw const TransactionDataException(
            'Each split transaction amount must be greater than zero.',
          );
        }
      }
    }

    // Business rule: get account to validate and update balance
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

    // Create transaction entity without persistence-managed fields
    // id, createdAt, updatedAt will be set by the repository/data source
    final transaction = Transaction(
      userId: params.userId.trim(),
      accountId: params.accountId.trim(),
      categoryId: params.categoryId.trim(),
      amount: params.amount,
      description: params.description.trim(),
      type: params.type,
      date: params.date,
      isRecurring: params.isRecurring,
      recurringType: params.recurringType,
      recurringInterval: params.recurringInterval,
      parentTransactionId: null,
      familyId: params.familyId?.trim(),
      isSplit: params.isSplit,
      splitTransactions: params.splitTransactions,
      attachments: params.attachments,
      tags: params.tags,
      notes: params.notes?.trim(),
      location: params.location?.trim(),
    );

    // Delegate to repository
    // The repository will handle:
    // 1. Creating the transaction with proper ID and timestamps
    // 2. Updating the account balance
    // 3. All in a single atomic operation
    return _transactionRepository.createTransaction(transaction);
  }
}
