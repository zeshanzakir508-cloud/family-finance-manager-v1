// lib/domain/usecases/account/transfer_between_accounts_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/account.dart';
import '../../entities/transaction.dart';
import '../../enums/transaction_type.dart';
import '../../repositories/account_repository.dart';
import '../../exceptions/account_exceptions.dart';
import '../../exceptions/transaction_exceptions.dart';

/// Parameters for [TransferBetweenAccountsUseCase].
class TransferBetweenAccountsParams extends Equatable {
  final String fromAccountId;
  final String toAccountId;
  final double amount;
  final String description;
  final String userId;
  final DateTime date;
  final String? categoryId;
  final String? familyId;

  const TransferBetweenAccountsParams({
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    required this.description,
    required this.userId,
    required this.date,
    this.categoryId,
    this.familyId,
  });

  @override
  List<Object?> get props => [
        fromAccountId,
        toAccountId,
        amount,
        description,
        userId,
        date,
        categoryId,
        familyId,
      ];
}

/// Transfer result containing the withdrawal and deposit transactions.
class TransferResult {
  final Transaction withdrawal;
  final Transaction deposit;

  const TransferResult({
    required this.withdrawal,
    required this.deposit,
  });
}

/// Use case for transferring money between accounts.
///
/// This use case handles transferring money from one account to another
/// with validation and business rules. The actual transfer operation
/// is performed atomically by the repository.
class TransferBetweenAccountsUseCase {
  final AccountRepository _accountRepository;

  const TransferBetweenAccountsUseCase({
    required AccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  /// Executes the transfer between accounts use case.
  ///
  /// [params] contains the source account, destination account, amount, and description.
  /// Returns a [TransferResult] containing the withdrawal and deposit transactions.
  /// Throws [AccountException] or [TransactionException] if validation fails or transfer fails.
  Future<TransferResult> call(TransferBetweenAccountsParams params) async {
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
      throw const TransactionDataException(
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

    // Business rule: currency must match (or implement conversion)
    if (fromAccount.currency != toAccount.currency) {
      throw const TransactionDataException(
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

    // Delegate to repository for atomic transfer
    // The repository handles:
    // 1. Creating withdrawal transaction
    // 2. Creating deposit transaction
    // 3. Updating source account balance
    // 4. Updating destination account balance
    // All in a single atomic operation
    final result = await _accountRepository.transferBetweenAccounts(
      fromAccountId: params.fromAccountId,
      toAccountId: params.toAccountId,
      amount: params.amount,
      description: params.description,
      userId: params.userId,
      date: params.date,
      categoryId: params.categoryId,
      familyId: params.familyId,
      fromAccountName: fromAccount.name,
      toAccountName: toAccount.name,
    );

    return TransferResult(
      withdrawal: result.withdrawal,
      deposit: result.deposit,
    );
  }
}
