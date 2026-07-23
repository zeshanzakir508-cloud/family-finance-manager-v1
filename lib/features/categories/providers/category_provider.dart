import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/category_controller.dart';
import '../repositories/category_repository.dart';
import '../services/category_service.dart';

/// Provider for CategoryService
final categoryServiceProvider = Provider<CategoryService>((ref) {
  throw UnimplementedError('CategoryService must be provided');
});

/// Provider for CategoryRepository
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final service = ref.watch(categoryServiceProvider);
  return CategoryRepository(service);
});

/// Provider for CategoryController
final categoryControllerProvider = Provider<CategoryController>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryController(repository);
});

/// Provider for category list
final categoriesProvider = Provider<List<CategoryModel>>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.categories;
});

/// Provider for filtered categories
final filteredCategoriesProvider = Provider<List<CategoryModel>>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.filteredCategories;
});

/// Provider for active categories
final activeCategoriesProvider = Provider<List<CategoryModel>>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.activeCategories;
});

/// Provider for archived categories
final archivedCategoriesProvider = Provider<List<CategoryModel>>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.archivedCategories;
});

/// Provider for selected category
final selectedCategoryProvider = Provider<CategoryModel?>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.selectedCategory;
});

/// Provider for category count
final categoryCountProvider = Provider<int>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.getCategoryCount();
});

/// Provider for active category count
final activeCategoryCountProvider = Provider<int>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.getActiveCategoryCount();
});

/// Provider for archived category count
final archivedCategoryCountProvider = Provider<int>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.getArchivedCategoryCount();
});

/// Provider for loading state
final categoriesLoadingProvider = Provider<bool>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.isLoading;
});

/// Provider for error message
final categoriesErrorProvider = Provider<String?>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.errorMessage;
});

/// Provider for search query
final categorySearchQueryProvider = Provider<String>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.searchQuery;
});

/// Provider for filter
final categoryFilterProvider = Provider<String>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.filter;
});

/// Provider for checking if categories exist
final hasCategoriesProvider = Provider<bool>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.hasCategories();
});

/// Provider for checking if active categories exist
final hasActiveCategoriesProvider = Provider<bool>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.hasActiveCategories();
});

/// Provider for getting a category by ID
final categoryByIdProvider = Provider.family<CategoryModel?, String>((ref, id) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.getCategoryById(id);
});

/// Provider for checking if a category is selected
final isCategorySelectedProvider = Provider.family<bool, String>((ref, id) {
  final controller = ref.watch(categoryControllerProvider);
  return controller.isCategorySelected(id);
});

/// Provider for category actions
final categoryActionsProvider = Provider<CategoryActions>((ref) {
  final controller = ref.watch(categoryControllerProvider);
  return CategoryActions(controller);
});

/// Provider for category validator
final categoryValidatorProvider = Provider<CategoryValidator>((ref) {
  return CategoryValidator();
});

/// Provider for category statistics
final categoryStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.getCategoryStatistics();
});

/// Provider for categories with transaction counts
final categoriesWithCountsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.getCategoriesWithCounts();
});

/// Provider for watching categories
final categoryStreamProvider = StreamProvider<List<CategoryModel>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.watchCategories();
});

/// Provider for watching categories by family
final categoryStreamByFamilyProvider = StreamProvider.family<List<CategoryModel>, String>((ref, familyId) {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.watchCategoriesByFamily(familyId);
});

/// Class containing all category actions
class CategoryActions {
  final CategoryController _controller;

  CategoryActions(this._controller);

  /// Create a new category
  Future<void> createCategory({
    required String name,
    String? description,
    String icon = 'category',
    String color = '#45B7D1',
    String? familyId,
  }) => _controller.createCategory(
    name: name,
    description: description,
    icon: icon,
    color: color,
    familyId: familyId,
  );

  /// Update a category
  Future<void> updateCategory({
    required String categoryId,
    String? name,
    String? description,
    String? icon,
    String? color,
  }) => _controller.updateCategory(
    categoryId: categoryId,
    name: name,
    description: description,
    icon: icon,
    color: color,
  );

  /// Delete a category
  Future<void> deleteCategory(String categoryId) => 
      _controller.deleteCategory(categoryId);

  /// Archive a category
  Future<void> archiveCategory(String categoryId) => 
      _controller.archiveCategory(categoryId);

  /// Restore a category
  Future<void> restoreCategory(String categoryId) => 
      _controller.restoreCategory(categoryId);

  /// Merge categories
  Future<void> mergeCategories({
    required String sourceCategoryId,
    required String targetCategoryId,
  }) => _controller.mergeCategories(
    sourceCategoryId: sourceCategoryId,
    targetCategoryId: targetCategoryId,
  );

  /// Set search query
  void setSearchQuery(String query) => _controller.setSearchQuery(query);

  /// Set filter
  void setFilter(String filter) => _controller.setFilter(filter);

  /// Clear search
  void clearSearch() => _controller.clearSearch();

  /// Reset filter
  void resetFilter() => _controller.resetFilter();

  /// Select a category
  void selectCategory(CategoryModel category) => _controller.selectCategory(category);

  /// Clear selection
  void clearSelection() => _controller.clearSelection();

  /// Refresh data
  Future<void> refresh() => _controller.refresh();

  /// Load a specific category
  Future<void> loadCategory(String categoryId) => _controller.loadCategory(categoryId);

  /// Validate category name
  String? validateName(String? name) => _controller.validateCategoryName(name);

  /// Check if category has transactions
  Future<bool> hasTransactions(String categoryId) async {
    final repository = _controller._repository;
    return await repository.hasTransactions(categoryId);
  }
}
