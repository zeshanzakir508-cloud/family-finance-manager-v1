// lib/domain/usecases/category/get_categories_by_type_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/category.dart';
import '../../enums/category_type.dart';
import '../../repositories/category_repository.dart';
import '../../exceptions/category_exceptions.dart';

/// Parameters for [GetCategoriesByTypeUseCase].
class GetCategoriesByTypeParams extends Equatable {
  final String userId;
  final CategoryType type;
  final bool includeArchived;

  const GetCategoriesByTypeParams({
    required this.userId,
    required this.type,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [userId, type, includeArchived];
}

/// Use case for getting categories by type for a specific user.
///
/// This use case handles retrieving all categories of a specific type
/// (income, expense, or transfer) for a user with optional filtering
/// for archived categories.
class GetCategoriesByTypeUseCase {
  final CategoryRepository _repository;

  const GetCategoriesByTypeUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  /// Executes the get categories by type use case.
  ///
  /// [params] contains the user ID, category type, and whether to include archived categories.
  /// Returns a list of [Category]s of the specified type belonging to the user.
  /// Throws [CategoryException] if validation fails or retrieval fails.
  Future<List<Category>> call(GetCategoriesByTypeParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const CategoryDataException('User ID cannot be empty.');
    }

    // Delegate to repository with type and includeArchived flag
    // The repository handles filtering at the data source level
    // This ensures consistent filtering behavior and optimal performance
    return _repository.getCategoriesByTypeForUser(
      params.userId.trim(),
      params.type,
      includeArchived: params.includeArchived,
    );
  }
}
