// lib/domain/usecases/account/update_account_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/account.dart';
import '../../repositories/account_repository.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [UpdateAccountUseCase].
class UpdateAccountParams extends Equatable {
  final String accountId;
  final String? name;
  final String? type;
  final double? balance;
  final String? currency;
  final bool? isDefault;
  final bool? isActive;
  final String? icon;
  final String? color;
  final String? description;
  final String? familyId;

  const UpdateAccountParams({
    required this.accountId,
    this.name,
    this.type,
    this.balance,
    this.currency,
    this.isDefault,
    this.isActive,
    this.icon,
    this.color,
    this.description,
    this.familyId,
  });

  @override
  List<Object?> get props => [
        accountId,
        name,
        type,
        balance,
        currency,
        isDefault,
        isActive,
        icon,
        color,
        description,
        familyId,
      ];
}

/// Use case for updating an existing account.
///
/// This use case handles updating an existing financial account with validation
/// and business rules before delegating to the repository.
class UpdateAccountUseCase {
  final AccountRepository _repository;

  const UpdateAccountUseCase({
    required AccountRepository repository,
  }) : _repository = repository;

  /// Executes the update account use case.
  ///
  /// [params] contains the account ID and fields to update.
  /// Returns the updated [Account] if successful.
  /// Throws [AccountException] if validation fails or update fails.
  Future<Account> call(UpdateAccountParams params) async {
    // Business rule: account ID must not be empty
    if (params.accountId.trim().isEmpty) {
      throw const AccountDataException('Account ID cannot be empty.');
    }

    // Business rule: at least one field must be provided for update
    if (params.name == null &&
        params.type == null &&
        params.balance == null &&
        params.currency == null &&
        params.isDefault == null &&
        params.isActive == null &&
        params.icon == null &&
        params.color == null &&
        params.description == null &&
        params.familyId == null) {
      throw const AccountDataException('At least one field must be provided for update.');
    }

    // Business rule: name must be valid if provided
    if (params.name != null) {
      if (params.name!.trim().isEmpty) {
        throw const AccountDataException('Account name cannot be empty.');
      }
      if (params.name!.trim().length < 2) {
        throw const AccountDataException('Account name must be at least 2 characters.');
      }
      if (params.name!.trim().length > 50) {
        throw const AccountDataException('Account name must not exceed 50 characters.');
      }
    }

    // Business rule: type must be valid if provided
    if (params.type != null) {
      if (params.type!.trim().isEmpty) {
        throw const AccountDataException('Account type cannot be empty.');
      }
      const validTypes = ['bank', 'cash', 'credit_card', 'investment', 'savings', 'other'];
      if (!validTypes.contains(params.type!.trim().toLowerCase())) {
        throw const AccountDataException('Invalid account type.');
      }
    }

    // Business rule: balance cannot be negative if provided
    if (params.balance != null && params.balance! < 0) {
      throw const AccountDataException('Account balance cannot be negative.');
    }

    // Business rule: currency must be valid if provided
    if (params.currency != null) {
      if (params.currency!.trim().isEmpty) {
        throw const AccountDataException('Currency cannot be empty.');
      }
      if (params.currency!.trim().length != 3) {
        throw const AccountDataException('Currency must be a 3-letter ISO code.');
      }
    }

    // Business rule: if familyId is provided, it must be valid
    if (params.familyId != null && params.familyId!.trim().isEmpty) {
      throw const AccountDataException('Family ID cannot be empty if provided.');
    }

    // Get current account to validate updates against existing state
    final currentAccount = await _repository.getAccount(params.accountId);

    // Business rule: cannot update a deleted/inactive account to active if it has constraints
    // This is a soft rule - the repository will handle the actual update
    if (params.isActive == true && !currentAccount.isActive) {
      // Reactivating an account - allow it, but let repository handle constraints
      // This is a business decision: accounts can be reactivated
    }

    // Business rule: if setting as default, repository will handle clearing other defaults
    if (params.isDefault == true) {
      // This is handled by the repository
    }

    // Build updated account with current values for unchanged fields
    // updatedAt is not set here - the repository/data source will set it
    final updatedAccount = Account(
      id: currentAccount.id!,
      userId: currentAccount.userId,
      name: params.name?.trim() ?? currentAccount.name,
      type: params.type?.trim().toLowerCase() ?? currentAccount.type,
      balance: params.balance ?? currentAccount.balance,
      currency: params.currency?.trim().toUpperCase() ?? currentAccount.currency,
      isDefault: params.isDefault ?? currentAccount.isDefault,
      isActive: params.isActive ?? currentAccount.isActive,
      icon: params.icon ?? currentAccount.icon,
      color: params.color ?? currentAccount.color,
      description: params.description?.trim() ?? currentAccount.description,
      familyId: params.familyId?.trim() ?? currentAccount.familyId,
      createdAt: currentAccount.createdAt,
      updatedAt: currentAccount.updatedAt, // Will be overridden by server timestamp in DataSource
    );

    // Delegate to repository
    return _repository.updateAccount(updatedAccount);
  }
}
