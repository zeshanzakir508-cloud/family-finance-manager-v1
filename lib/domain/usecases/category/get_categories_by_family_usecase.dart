// lib/domain/usecases/category/get_categories_by_family_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/category.dart';
import '../../repositories/category_repository.dart';
import '../../exceptions/category_exceptions.dart';

/// Parameters for [GetCategoriesByFamilyUseCase].
class GetCategoriesByFamilyParams extends Equatable {
  final String familyId;
  final bool includeArchived;

  const GetCategoriesByFamilyParams({
    required this.familyId,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [familyId, includeArchived];
}

/// Use case for getting all categories belonging to a family.
///
/// This use case handles retrieving all categories for a specific family
/// with optional filtering for archived categories.
class GetCategoriesByFamilyUseCase {
  final CategoryRepository _repository;

  const GetCategoriesByFamilyUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  /// Executes the get categories by family use case.
  ///
  /// [params] contains the family ID and whether to include archived categories.
  /// Returns a list of [Category]s belonging to the family.
  /// Throws [CategoryException] if validation fails or retrieval fails.
  Future<List<Category>> call(GetCategoriesByFamilyParams params) async {
    // Business rule: family ID must not be empty
    if (params.familyId.trim().isEmpty) {
      throw const CategoryDataException('Family ID cannot be empty.');
    }

    // Delegate to repository with includeArchived flag
    // The repository handles filtering at the data source level
    // This ensures consistent filtering behavior and optimal performance
    return _repository.getCategoriesByFamilyId(
      params.familyId,
      includeArchived: params.includeArchived,
    );
  }
}
