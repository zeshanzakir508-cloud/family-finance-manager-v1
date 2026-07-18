// lib/domain/usecases/category/get_categories_by_user_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/category.dart';
import '../../repositories/category_repository.dart';
import '../../exceptions/category_exceptions.dart';

/// Parameters for [GetCategoriesByUserUseCase].
class GetCategoriesByUserParams extends Equatable {
  final String userId;
  final bool includeArchived;

  const GetCategoriesByUserParams({
    required this.userId,
    this.includeArchived = false,
  });

  @override
  List<Object?> get props => [userId, includeArchived];
}

/// Use case for getting all categories belonging to a user.
///
/// This use case handles retrieving all categories for a specific user
/// with optional filtering for archived categories.
class GetCategoriesByUserUseCase {
  final CategoryRepository _repository;

  const GetCategoriesByUserUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  /// Executes the get categories by user use case.
  ///
  /// [params] contains the user ID and whether to include archived categories.
  /// Returns a list of [Category]s belonging to the user.
  /// Throws [CategoryException] if validation fails or retrieval fails.
  Future<List<Category>> call(GetCategoriesByUserParams params) async {
    // Business rule: user ID must not be empty
    if (params.userId.trim().isEmpty) {
      throw const CategoryDataException('User ID cannot be empty.');
    }

    // Delegate to repository with includeArchived flag
    // The repository handles filtering at the data source level
    // This ensures consistent filtering behavior and optimal performance
    return _repository.getCategoriesByUserId(
      params.userId.trim(),
      includeArchived: params.includeArchived,
    );
  }
}
