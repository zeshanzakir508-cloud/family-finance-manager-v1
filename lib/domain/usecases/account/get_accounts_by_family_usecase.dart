// lib/domain/usecases/account/get_accounts_by_family_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/account.dart';
import '../../repositories/account_repository.dart';
import '../../exceptions/account_exceptions.dart';

/// Parameters for [GetAccountsByFamilyUseCase].
class GetAccountsByFamilyParams extends Equatable {
  final String familyId;
  final bool includeArchived;

  const GetAccountsByFamilyParams({
    required this.familyId,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [familyId, includeArchived];
}

/// Use case for getting all accounts belonging to a family.
///
/// This use case handles retrieving all accounts for a specific family
/// with optional filtering for archived accounts.
class GetAccountsByFamilyUseCase {
  final AccountRepository _repository;

  const GetAccountsByFamilyUseCase({
    required AccountRepository repository,
  }) : _repository = repository;

  /// Executes the get accounts by family use case.
  ///
  /// [params] contains the family ID and whether to include archived accounts.
  /// Returns a list of [Account]s belonging to the family.
  /// Throws [AccountException] if validation fails or retrieval fails.
  Future<List<Account>> call(GetAccountsByFamilyParams params) async {
    // Business rule: family ID must not be empty
    if (params.familyId.trim().isEmpty) {
      throw const AccountDataException('Family ID cannot be empty.');
    }

    // Delegate to repository with includeArchived flag
    // The repository handles filtering at the data source level
    // This ensures consistent filtering behavior and optimal performance
    return _repository.getAccountsByFamilyId(
      params.familyId,
      includeArchived: params.includeArchived,
    );
  }
}
