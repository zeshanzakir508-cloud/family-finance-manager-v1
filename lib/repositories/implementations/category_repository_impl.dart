// lib/repositories/implementations/category_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../interfaces/category_repository.dart';
import '../interfaces/base_repository.dart';
import '../../services/firestore_service.dart';
import '../../constants/firestore_constants.dart';
import '../../models/category_model.dart';
import '../../exceptions/app_exception.dart';
import '../../exceptions/firestore_exception.dart';

/// Implementation of CategoryRepository that handles all category-related Firestore operations.
///
/// This repository follows the single responsibility principle and only handles
/// data persistence. All business logic should be in domain managers/use cases.
///
/// Categories support hierarchical structures through parent-child relationships.
/// The repository provides methods to query categories by parent, get category
/// trees, and manage category ordering.
class CategoryRepositoryImpl extends BaseRepository implements CategoryRepository {
  CategoryRepositoryImpl({
    required FirestoreService firestoreService,
  }) : super(firestoreService);

  @override
  String get collectionPath => FirestoreConstants.categories;

  // ==================== Private Helpers ====================

  /// Updates a subset of category fields while maintaining version consistency.
  Future<void> _updateFields(
    String categoryId,
    Map<String, dynamic> fields,
  ) async {
    try {
      final category = await getCategory(categoryId);
      if (category == null) {
        throw AppException('Category not found: $categoryId');
      }

      final now = DateTime.now();
      final updateData = {
        ...fields,
        FirestoreConstants.updatedAt: now,
        FirestoreConstants.version: category.version + 1,
      };

      await updateDocument(categoryId, updateData);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update category fields for $categoryId: ${e.toString()}');
    }
  }

  /// Recursively builds a category tree from a list of categories.
  ///
  /// Why: This is a pure helper that transforms a flat list into a hierarchical
  /// structure. It uses copyWith to create new immutable category instances
  /// with their children set, preserving immutability.
  List<CategoryModel> _buildCategoryTree({
    required List<CategoryModel> categories,
    String? parentId,
  }) {
    final children = categories
        .where((category) => category.parentId == parentId)
        .toList();

    // Sort children by order (if available) or by name
    children.sort((a, b) {
      final orderA = a.order ?? 0;
      final orderB = b.order ?? 0;
      if (orderA != orderB) return orderA.compareTo(orderB);
      return a.name.compareTo(b.name);
    });

    // Recursively build children and create new immutable instances
    final result = <CategoryModel>[];
    for (final child in children) {
      final grandchildren = _buildCategoryTree(
        categories: categories,
        parentId: child.id,
      );
      // Use copyWith to create a new instance with children, preserving immutability
      result.add(child.copyWith(children: grandchildren));
    }

    return result;
  }

  /// Performs a batch update with version increment using a transaction.
  ///
  /// Why: This ensures versions are incremented atomically, preventing
  /// race conditions when multiple clients modify categories simultaneously.
  ///
  /// Note: This method handles all validation and reads inside the transaction
  /// to ensure consistency and avoid duplicate reads.
  Future<void> _batchUpdateCategories({
    required String familyId,
    required String parentId,
    required Map<String, Map<String, dynamic>> updates,
  }) async {
    try {
      final docRefs = updates.keys.map((id) => getDocumentReference(id)).toList();

      await runTransaction((transaction) async {
        final updateData = <String, Map<String, dynamic>>{};

        // Read all documents and validate within the transaction
        for (final docRef in docRefs) {
          final doc = await transaction.get(docRef);
          if (!doc.exists) {
            throw AppException('Category not found: ${docRef.id}');
          }

          final data = doc.data()!;
          
          // Validate family ID
          if (data[FirestoreConstants.familyId] != familyId) {
            throw AppException(
              'Category ${docRef.id} does not belong to family $familyId',
            );
          }
          
          // Validate parent ID
          if (data[FirestoreConstants.parentId] != parentId) {
            throw AppException(
              'Category ${docRef.id} is not a child of $parentId',
            );
          }

          final currentVersion = data[FirestoreConstants.version] as int? ?? 0;
          final now = DateTime.now();
          
          final updateDataForDoc = {
            ...updates[docRef.id]!,
            FirestoreConstants.updatedAt: now,
            FirestoreConstants.version: currentVersion + 1,
          };
          
          updateData[docRef.id] = updateDataForDoc;
        }

        // Apply all updates within the same transaction
        for (final entry in updateData.entries) {
          final docRef = getDocumentReference(entry.key);
          transaction.update(docRef, entry.value);
        }
      });
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to batch update categories: ${e.toString()}');
    }
  }

  // ==================== Public Methods ====================

  @override
  Future<void> createCategory(CategoryModel category) async {
    try {
      final now = DateTime.now();
      
      final newCategory = category.copyWith(
        version: 1,
        createdAt: now,
        updatedAt: now,
      );
      
      await setDocument(
        category.id,
        newCategory.toJson(),
      );
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to create category ${category.id}: ${e.toString()}');
    }
  }

  @override
  Future<CategoryModel?> getCategory(String categoryId) async {
    try {
      final doc = await getDocument(categoryId);
      if (!doc.exists) return null;
      return CategoryModel.fromJson(doc.data()!);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get category $categoryId: ${e.toString()}');
    }
  }

  @override
  Stream<CategoryModel?> watchCategory(String categoryId) {
    return watchDocument(categoryId).map((doc) {
      if (!doc.exists) return null;
      return CategoryModel.fromJson(doc.data()!);
    });
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    try {
      final existing = await getCategory(category.id);
      if (existing == null) {
        throw AppException('Category not found: ${category.id}');
      }

      final now = DateTime.now();
      final updatedCategory = category.copyWith(
        updatedAt: now,
        version: existing.version + 1,
      );
      
      await updateDocument(category.id, updatedCategory.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update category ${category.id}: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      final category = await getCategory(categoryId);
      if (category == null) {
        throw AppException('Category not found: $categoryId');
      }

      final now = DateTime.now();
      final updatedCategory = category.copyWith(
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
        version: category.version + 1,
      );
      
      await updateDocument(categoryId, updatedCategory.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to delete category $categoryId: ${e.toString()}');
    }
  }

  @override
  Future<void> restoreCategory(String categoryId) async {
    try {
      final category = await getCategory(categoryId);
      if (category == null) {
        throw AppException('Category not found: $categoryId');
      }

      final now = DateTime.now();
      final updatedCategory = category.copyWith(
        isDeleted: false,
        deletedAt: null,
        updatedAt: now,
        version: category.version + 1,
      );
      
      await updateDocument(categoryId, updatedCategory.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to restore category $categoryId: ${e.toString()}');
    }
  }

  @override
  Future<bool> categoryExists(String categoryId) async {
    try {
      return await documentExists(categoryId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to check category existence for $categoryId: ${e.toString()}');
    }
  }

  // ==================== Query Methods ====================

  @override
  Future<List<CategoryModel>> getCategoriesByFamily({
    required String familyId,
    bool includeDeleted = false,
    String? type,
  }) async {
    try {
      var query = firestoreService
          .collection(collectionPath)
          .where(FirestoreConstants.familyId, isEqualTo: familyId);

      if (!includeDeleted) {
        query = query.where(FirestoreConstants.isDeleted, isEqualTo: false);
      }

      if (type != null) {
        query = query.where(FirestoreConstants.type, isEqualTo: type);
      }

      final docs = await query
          .orderBy(FirestoreConstants.order, descending: false)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get categories for family $familyId: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getCategoriesByParent({
    required String familyId,
    String? parentId,
    bool includeDeleted = false,
    String? type,
  }) async {
    try {
      var query = firestoreService
          .collection(collectionPath)
          .where(FirestoreConstants.familyId, isEqualTo: familyId)
          .where(FirestoreConstants.parentId, isEqualTo: parentId);

      if (!includeDeleted) {
        query = query.where(FirestoreConstants.isDeleted, isEqualTo: false);
      }

      if (type != null) {
        query = query.where(FirestoreConstants.type, isEqualTo: type);
      }

      final docs = await query
          .orderBy(FirestoreConstants.order, descending: false)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get categories for parent $parentId: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getCategoryTree({
    required String familyId,
    bool includeDeleted = false,
    String? type,
  }) async {
    try {
      final categories = await getCategoriesByFamily(
        familyId: familyId,
        includeDeleted: includeDeleted,
        type: type,
      );

      return _buildCategoryTree(
        categories: categories,
        parentId: null,
      );
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get category tree for family $familyId: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getCategoryPath({
    required String familyId,
    required String categoryId,
  }) async {
    try {
      final path = <CategoryModel>[];
      String? currentId = categoryId;

      while (currentId != null) {
        final category = await getCategory(currentId);
        if (category == null) break;
        
        // Validate the category belongs to the specified family
        if (category.familyId != familyId) {
          throw AppException('Category $currentId does not belong to family $familyId');
        }
        
        path.insert(0, category);
        currentId = category.parentId;
      }

      return path;
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get category path for $categoryId: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getRootCategories({
    required String familyId,
    bool includeDeleted = false,
    String? type,
  }) async {
    return getCategoriesByParent(
      familyId: familyId,
      parentId: null,
      includeDeleted: includeDeleted,
      type: type,
    );
  }

  @override
  Future<List<CategoryModel>> getSubcategories({
    required String familyId,
    required String parentId,
    bool includeDeleted = false,
    String? type,
  }) async {
    return getCategoriesByParent(
      familyId: familyId,
      parentId: parentId,
      includeDeleted: includeDeleted,
      type: type,
    );
  }

  @override
  Future<List<CategoryModel>> getCategoriesByType({
    required String familyId,
    required String type,
    bool includeDeleted = false,
  }) async {
    return getCategoriesByFamily(
      familyId: familyId,
      includeDeleted: includeDeleted,
      type: type,
    );
  }

  @override
  Stream<List<CategoryModel>> watchCategoriesByFamily({
    required String familyId,
    bool includeDeleted = false,
    String? type,
  }) {
    try {
      var query = firestoreService
          .collection(collectionPath)
          .where(FirestoreConstants.familyId, isEqualTo: familyId);

      if (!includeDeleted) {
        query = query.where(FirestoreConstants.isDeleted, isEqualTo: false);
      }

      if (type != null) {
        query = query.where(FirestoreConstants.type, isEqualTo: type);
      }

      return query
          .orderBy(FirestoreConstants.order, descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .where((doc) => doc.exists)
            .map((doc) => CategoryModel.fromJson(doc.data()))
            .toList();
      });
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to watch categories for family $familyId: ${e.toString()}');
    }
  }

  @override
  Future<int> getCategoryCount({
    required String familyId,
    String? type,
    bool includeDeleted = false,
  }) async {
    try {
      var query = firestoreService
          .collection(collectionPath)
          .where(FirestoreConstants.familyId, isEqualTo: familyId);

      if (!includeDeleted) {
        query = query.where(FirestoreConstants.isDeleted, isEqualTo: false);
      }

      if (type != null) {
        query = query.where(FirestoreConstants.type, isEqualTo: type);
      }

      final snapshot = await query.count().get();
      return snapshot.count;
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get category count for family $familyId: ${e.toString()}');
    }
  }

  // ==================== Category-Specific Updates ====================

  @override
  Future<void> updateCategoryName({
    required String categoryId,
    required String name,
  }) async {
    await _updateFields(
      categoryId,
      {FirestoreConstants.categoryName: name},
    );
  }

  @override
  Future<void> updateCategoryIcon({
    required String categoryId,
    required String? icon,
  }) async {
    await _updateFields(
      categoryId,
      {FirestoreConstants.icon: icon},
    );
  }

  @override
  Future<void> updateCategoryColor({
    required String categoryId,
    required String? color,
  }) async {
    await _updateFields(
      categoryId,
      {FirestoreConstants.color: color},
    );
  }

  @override
  Future<void> updateCategoryOrder({
    required String categoryId,
    required int order,
  }) async {
    await _updateFields(
      categoryId,
      {FirestoreConstants.order: order},
    );
  }

  @override
  Future<void> updateCategoryParent({
    required String categoryId,
    required String? parentId,
  }) async {
    await _updateFields(
      categoryId,
      {FirestoreConstants.parentId: parentId},
    );
  }

  @override
  Future<void> moveCategory({
    required String categoryId,
    required String? newParentId,
    required int newOrder,
  }) async {
    await _updateFields(
      categoryId,
      {
        FirestoreConstants.parentId: newParentId,
        FirestoreConstants.order: newOrder,
      },
    );
  }

  @override
  Future<void> reorderCategories({
    required String familyId,
    required String parentId,
    required List<String> categoryIds,
  }) async {
    try {
      // Build updates map
      final updates = <String, Map<String, dynamic>>{};
      
      for (int i = 0; i < categoryIds.length; i++) {
        final categoryId = categoryIds[i];
        updates[categoryId] = {
          FirestoreConstants.order: i,
        };
      }

      // Apply all updates atomically in a single transaction with validation
      await _batchUpdateCategories(
        familyId: familyId,
        parentId: parentId,
        updates: updates,
      );
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to reorder categories: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, List<CategoryModel>>> getCategoriesGroupedByType({
    required String familyId,
    bool includeDeleted = false,
  }) async {
    try {
      final categories = await getCategoriesByFamily(
        familyId: familyId,
        includeDeleted: includeDeleted,
      );

      final grouped = <String, List<CategoryModel>>{};
      
      for (final category in categories) {
        final type = category.type ?? 'other';
        if (!grouped.containsKey(type)) {
          grouped[type] = [];
        }
        grouped[type]!.add(category);
      }

      // Sort categories within each group
      for (final type in grouped.keys) {
        grouped[type]!.sort((a, b) {
          final orderA = a.order ?? 0;
          final orderB = b.order ?? 0;
          if (orderA != orderB) return orderA.compareTo(orderB);
          return a.name.compareTo(b.name);
        });
      }

      return grouped;
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get categories grouped by type: ${e.toString()}');
    }
  }
}
