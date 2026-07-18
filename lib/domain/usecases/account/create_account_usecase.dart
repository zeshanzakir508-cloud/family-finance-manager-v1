// lib/domain/usecases/account/create_account_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/account.dart';
import '../../repositories/account_repository.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [CreateAccountUseCase].
class CreateAccountParams extends Equatable {
  final String userId;
  final String name;
  final String type;
  final double balance;
  final String currency;
  final bool isDefault;
  final String? icon;
  final String? color;
  final String? description;
  final String? familyId;

  const CreateAccountParams({
    required this.userId,
    required this.name,
    required this.type,
    this.balance = 0.0,
    this.currency = 'USD',
    this.isDefault = false,
    this.icon,
    this.color,
    this.description,
    this.familyId,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        type,
        balance,
        currency,
        isDefault,
        icon,
        color,
        description,
        familyId,
      ];
}

/// Use case for creating a new account.
///
/// This use case handles creating a new financial account with validation
/// and business rules before delegating to the repository.
class CreateAccountUseCase {
  final AccountRepository _repository;

  const CreateAccountUseCase({
    required AccountRepository repository,
  }) : _repository = repository;

  /// Executes the create account use case.
  ///
  /// [params] contains the account details for creation.
  /// Returns the created [Account] if successful.
  /// Throws [AccountException] if validation fails or creation fails.
  Future<Account> call(CreateAccountParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const AccountDataException('User ID cannot be empty.');
    }

    // Business rule: account name must not be empty
    if (params.name.trim().isEmpty) {
      throw const AccountDataException('Account name cannot be empty.');
    }

    // Business rule: account name must be at least 2 characters
    if (params.name.trim().length < 2) {
      throw const AccountDataException('Account name must be at least 2 characters.');
    }

    // Business rule: account name must not exceed 50 characters
    if (params.name.trim().length > 50) {
      throw const AccountDataException('Account name must not exceed 50 characters.');
    }

    // Business rule: account type must not be empty
    if (params.type.trim().isEmpty) {
      throw const AccountDataException('Account type cannot be empty.');
    }

    // Business rule: account type must be valid
    const validTypes = ['bank', 'cash', 'credit_card', 'investment', 'savings', 'other'];
    if (!validTypes.contains(params.type.trim().toLowerCase())) {
      throw const AccountDataException('Invalid account type.');
    }

    // Business rule: balance cannot be negative
    if (params.balance < 0) {
      throw const AccountDataException('Account balance cannot be negative.');
    }

    // Business rule: currency must be valid
    if (params.currency.trim().isEmpty) {
      throw const AccountDataException('Currency cannot be empty.');
    }

    // Business rule: currency must be 3 characters (ISO code)
    if (params.currency.trim().length != 3) {
      throw const AccountDataException('Currency must be a 3-letter ISO code.');
    }

    // Business rule: if familyId is provided, it must be valid
    if (params.familyId != null && params.familyId!.trim().isEmpty) {
      throw const AccountDataException('Family ID cannot be empty if provided.');
    }

    // Sanitize inputs
    final sanitizedName = params.name.trim();
    final sanitizedType = params.type.trim().toLowerCase();
    final sanitizedCurrency = params.currency.trim().toUpperCase();

    // Create account entity without persistence-managed fields
    // id, createdAt, updatedAt will be set by the repository/data source
    final account = Account(
      userId: params.userId.trim(),
      name: sanitizedName,
      type: sanitizedType,
      balance: params.balance,
      currency: sanitizedCurrency,
      isDefault: params.isDefault,
      isActive: true,
      icon: params.icon,
      color: params.color,
      description: params.description?.trim(),
      familyId: params.familyId?.trim(),
    );

    // Delegate to repository
    return _repository.createAccount(account);
  }
}
