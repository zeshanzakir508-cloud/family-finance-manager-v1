// lib/domain/usecases/transaction/transfer_money_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/transaction.dart';
import '../../entities/account.dart';
import '../../enums/transaction_type.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/account_repository.dart';
import '../../exceptions/transaction_exceptions.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [TransferMoneyUseCase].
class TransferMoneyParams extends Equatable {
  final String userId;
  final String fromAccountId;
  final String toAccountId;
  final double amount;
  final String description;
  final DateTime date;
  final String? categoryId;
  final String? familyId;

  const TransferMoneyParams({
    required this.userId,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    required this.description,
    required this.date,
    this.categoryId,
    this.familyId,
  });

  @override
  List<Object?> get props => [
        userId,
        fromAccountId,
        toAccountId,
        amount,
        description,
        date,
        categoryId,
        familyId,
      ];
}

/// Result containing the withdrawal and deposit transactions.
class TransferMoneyResult extends Equatable {
  final Transaction withdrawal;
  final Transaction deposit;

  const TransferMoneyResult({
    required this.withdrawal,
    required this.deposit,
  });

  @override
  List<Object?> get props => [withdrawal, deposit];
}

/// Use case for transferring money between accounts.
///
/// This use case handles transferring money from one account to another
/// with validation, balance checking, and transaction creation.
/// All operations are performed atomically by the repository.
class TransferMoneyUseCase {
  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;

  const TransferMoneyUseCase({
    required TransactionRepository transactionRepository,
    required AccountRepository accountRepository,
  })  : _transactionRepository = transactionRepository,
        _accountRepository = accountRepository;

  /// Executes the transfer money use case.
  ///
  /// [params] contains the source account, destination account, amount, and description.
  /// Returns a [TransferMoneyResult] containing the withdrawal and deposit transactions.
  /// Throws [TransactionException] or [AccountException] if validation fails or transfer fails.
  Future<TransferMoneyResult> call(TransferMoneyParams params) async {
    // Business rule: amount must be positive
    if (params.amount <= 0) {
      throw const TransactionDataException('Transfer amount must be greater than zero.');
    }

    // Business rule: description must not be empty
    if (params.description.trim().isEmpty) {
      throw const TransactionDataException('Transfer description cannot be empty.');
    }

    // Business rule: from account ID must not be empty
    if (params.fromAccountId.trim().isEmpty) {
      throw const AccountDataException('Source account ID cannot be empty.');
    }

    // Business rule: to account ID must not be empty
    if (params.toAccountId.trim().isEmpty) {
      throw const AccountDataException('Destination account ID cannot be empty.');
    }

    // Business rule: cannot transfer to the same account
    if (params.fromAccountId == params.toAccountId) {
      throw const TransactionDataException('Cannot transfer to the same account.');
    }

    // Get source account to validate
    final fromAccount = await _accountRepository.getAccount(params.fromAccountId);

    // Business rule: source account must belong to the user
    if (fromAccount.userId != params.userId) {
      throw const AccountDataException('Source account does not belong to this user.');
    }

    // Business rule: source account must be active
    if (!fromAccount.isActive) {
      throw const AccountDataException('Source account is archived. Please restore it first.');
    }

    // Business rule: sufficient balance
    if (fromAccount.balance < params.amount) {
      throw TransactionDataException(
        'Insufficient balance. Available: ${fromAccount.balance.toStringAsFixed(2)}',
      );
    }

    // Get destination account to validate
    final toAccount = await _accountRepository.getAccount(params.toAccountId);

    // Business rule: destination account must belong to the user
    if (toAccount.userId != params.userId) {
      throw const AccountDataException('Destination account does not belong to this user.');
    }

    // Business rule: destination account must be active
    if (!toAccount.isActive) {
      throw const AccountDataException(
        'Destination account is archived. Please restore it first.',
      );
    }

    // Business rule: currency must match
    if (fromAccount.currency != toAccount.currency) {
      throw TransactionDataException(
        'Currency mismatch. Source: ${fromAccount.currency}, Destination: ${toAccount.currency}',
      );
    }

    // Business rule: transfer amount cannot exceed max allowed
    const maxTransferAmount = 1000000.0;
    if (params.amount > maxTransferAmount) {
      throw TransactionDataException(
        'Transfer amount exceeds maximum allowed (${maxTransferAmount.toStringAsFixed(2)}).',
      );
    }

    // Business rule: if categoryId is provided, it must be valid
    if (params.categoryId != null && params.categoryId!.trim().isEmpty) {
      throw const TransactionDataException('Category ID cannot be empty if provided.');
    }

    // Business rule: if familyId is provided, it must be valid
    if (params.familyId != null && params.familyId!.trim().isEmpty) {
      throw const TransactionDataException('Family ID cannot be empty if provided.');
    }

    // Delegate to repository for atomic transfer
    // The repository handles:
    // 1. Creating withdrawal transaction
    // 2. Creating deposit transaction
    // 3. Updating source account balance
    // 4. Updating destination account balance
    // All in a single atomic operation
    final result = await _transactionRepository.transferMoney(
      fromAccountId: params.fromAccountId.trim(),
      toAccountId: params.toAccountId.trim(),
      amount: params.amount,
      description: params.description.trim(),
      userId: params.userId.trim(),
      date: params.date,
      categoryId: params.categoryId?.trim(),
      familyId: params.familyId?.trim(),
    );

    return TransferMoneyResult(
      withdrawal: result.withdrawal,
      deposit: result.deposit,
    );
  }
}
