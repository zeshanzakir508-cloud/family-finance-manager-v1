// lib/domain/usecases/transaction/split_transaction_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/transaction.dart';
import '../../entities/split_transaction.dart';
import '../../enums/transaction_type.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/account_repository.dart';
import '../../exceptions/transaction_exceptions.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [SplitTransactionUseCase].
class SplitTransactionParams extends Equatable {
  final String userId;
  final String accountId;
  final TransactionType type;
  final double totalAmount;
  final String description;
  final DateTime date;
  final List<SplitTransaction> splits;
  final String? familyId;
  final List<String>? attachments;
  final List<String>? tags;
  final String? notes;
  final String? location;

  const SplitTransactionParams({
    required this.userId,
    required this.accountId,
    required this.type,
    required this.totalAmount,
    required this.description,
    required this.date,
    required this.splits,
    this.familyId,
    this.attachments,
    this.tags,
    this.notes,
    this.location,
  });

  @override
  List<Object?> get props => [
        userId,
        accountId,
        type,
        totalAmount,
        description,
        date,
        splits,
        familyId,
        attachments,
        tags,
        notes,
        location,
      ];
}

/// Use case for creating a split transaction.
///
/// A split transaction is a single transaction that is divided across
/// multiple categories. This use case handles validation, creating the
/// parent transaction and the individual split transactions.
/// Supports both income and expense transactions.
class SplitTransactionUseCase {
  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;

  const SplitTransactionUseCase({
    required TransactionRepository transactionRepository,
    required AccountRepository accountRepository,
  })  : _transactionRepository = transactionRepository,
        _accountRepository = accountRepository;

  /// Executes the split transaction use case.
  ///
  /// [params] contains the transaction details and the list of splits.
  /// Returns the created [Transaction] (parent).
  /// Throws [TransactionException] or [AccountException] if validation fails.
  Future<Transaction> call(SplitTransactionParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const TransactionDataException('User ID cannot be empty.');
    }

    // Business rule: account ID must not be empty
    if (params.accountId.trim().isEmpty) {
      throw const TransactionDataException('Account ID cannot be empty.');
    }

    // Business rule: transaction type must be valid
    if (params.type != TransactionType.income &&
        params.type != TransactionType.expense) {
      throw const TransactionDataException(
        'Invalid transaction type. Must be income or expense.',
      );
    }

    // Business rule: total amount must be positive
    if (params.totalAmount <= 0) {
      throw const TransactionDataException('Total transaction amount must be greater than zero.');
    }

    // Business rule: description must not be empty
    if (params.description.trim().isEmpty) {
      throw const TransactionDataException('Transaction description cannot be empty.');
    }

    // Business rule: description length validation
    if (params.description.trim().length > 500) {
      throw const TransactionDataException('Description must not exceed 500 characters.');
    }

    // Business rule: splits must not be empty
    if (params.splits.isEmpty) {
      throw const TransactionDataException(
        'At least one split category is required.',
      );
    }

    // Business rule: minimum 2 splits for a split transaction
    if (params.splits.length < 2) {
      throw const TransactionDataException(
        'A split transaction must have at least 2 categories.',
      );
    }

    // Business rule: max splits validation
    const maxSplits = 20;
    if (params.splits.length > maxSplits) {
      throw TransactionDataException(
        'Cannot split into more than $maxSplits categories.',
      );
    }

    // Business rule: validate each split
    for (final split in params.splits) {
      // Business rule: category ID must not be empty
      if (split.categoryId.trim().isEmpty) {
        throw const TransactionDataException(
          'Each split must have a category ID.',
        );
      }

      // Business rule: split amount must be positive
      if (split.amount <= 0) {
        throw const TransactionDataException(
          'Each split amount must be greater than zero.',
        );
      }

      // Business rule: split amount must not exceed total
      if (split.amount > params.totalAmount) {
        throw TransactionDataException(
          'Split amount (${split.amount.toStringAsFixed(2)}) exceeds total amount (${params.totalAmount.toStringAsFixed(2)}).',
        );
      }
    }

    // Business rule: sum of splits must equal total amount
    final splitSum = params.splits.fold<double>(
      0.0,
      (sum, split) => sum + split.amount,
    );
    if ((splitSum - params.totalAmount).abs() > 0.001) {
      throw TransactionDataException(
        'Split amounts sum (${splitSum.toStringAsFixed(2)}) does not match total amount (${params.totalAmount.toStringAsFixed(2)}).',
      );
    }

    // Business rule: split categories must be unique
    final categoryIds = params.splits.map((s) => s.categoryId).toSet();
    if (categoryIds.length != params.splits.length) {
      throw const TransactionDataException(
        'Each split must have a unique category.',
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
      if (account.balance < params.totalAmount) {
        throw TransactionDataException(
          'Insufficient balance. Available: ${account.balance.toStringAsFixed(2)}',
        );
      }
    }

    // Delegate to repository
    // The repository will handle:
    // 1. Creating the parent transaction
    // 2. Creating individual split transactions
    // 3. Linking them with parentTransactionId
    // 4. Updating account balance
    // 5. All in a single atomic operation
    return _transactionRepository.createSplitTransaction(
      userId: params.userId.trim(),
      accountId: params.accountId.trim(),
      type: params.type,
      totalAmount: params.totalAmount,
      description: params.description.trim(),
      date: params.date,
      splits: params.splits,
      familyId: params.familyId?.trim(),
      attachments: params.attachments,
      tags: params.tags,
      notes: params.notes?.trim(),
      location: params.location?.trim(),
    );
  }
}
