// lib/data/datasources/remote/firestore_category_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/exceptions/category_exceptions.dart';
import '../../models/category_model.dart';

/// Data source for Firestore Category operations.
///
/// This class handles all direct communication with Firestore for category-related
/// operations and converts Firestore results to models. It is the only layer that
/// should contain Firestore query logic for categories.
///
/// This class MUST NOT contain any business logic, validation, UI code, or Riverpod code.
class FirestoreCategoryDataSource {
  final FirebaseFirestore _firestore;

  FirestoreCategoryDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  /// Collection reference for categories.
  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _firestore.collection('categories');

  /// Document reference for a specific category.
  DocumentReference<Map<String, dynamic>> _categoryDocument(String categoryId) =>
      _categoriesCollection.doc(categoryId);

  /// Executes a Firestore operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(_handleFirestoreException(e), stackTrace);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const CategoryDataException('Unexpected category data source error.'),
        stackTrace,
      );
    }
  }

  /// Executes a stream Firestore operation with consistent error handling.
  Stream<T> _executeStream<T>(
    Stream<T> Function() action,
  ) async* {
    try {
      await for (final value in action()) {
        yield value;
      }
    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(_handleFirestoreException(e), stackTrace);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const CategoryDataException('Unexpected category stream error.'),
        stackTrace,
      );
    }
  }

  /// Converts FirestoreException to domain CategoryException.
  CategoryException _handleFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const CategoryDataException('Permission denied to access category data.');
      case 'not-found':
        return const CategoryNotFoundException('Category not found.');
      case 'already-exists':
        return const CategoryDataException('Category already exists.');
      case 'failed-precondition':
        return const CategoryDataException('Precondition failed for category operation.');
      case 'aborted':
        return const CategoryDataException('Category operation was aborted.');
      case 'out-of-range':
        return const CategoryDataException('Category operation out of range.');
      case 'unimplemented':
        return const CategoryDataException('Category operation not implemented.');
      case 'internal':
        return const CategoryDataException('Internal error accessing category data.');
      case 'unavailable':
        return const CategoryDataException('Category service is temporarily unavailable.');
      case 'deadline-exceeded':
        return const CategoryDataException('Category operation timed out.');
      default:
        return CategoryDataException('Category error: ${e.message ?? 'Unknown error'}');
    }
  }

  /// Converts Firestore DocumentSnapshot to CategoryModel.
  CategoryModel _documentToModel(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const CategoryDataException('Category document data is null.');
    }

    return CategoryModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      type: data['type'] as String? ?? '',
      icon: data['icon'] as String?,
      color: data['color'] as String?,
      description: data['description'] as String?,
      isDefault: data['isDefault'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
      familyId: data['familyId'] as String?,
      parentId: data['parentId'] as String?,
      order: data['order'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts CategoryModel to Firestore map for creation.
  Map<String, dynamic> _modelToCreateMap(CategoryModel model) {
    return {
      'userId': model.userId,
      'name': model.name,
      'type': model.type,
      'icon': model.icon,
      'color': model.color,
      'description': model.description,
      'isDefault': model.isDefault,
      'isActive': model.isActive,
      'familyId': model.familyId,
      'parentId': model.parentId,
      'order': model.order,
    };
  }

  /// Converts CategoryModel to Firestore map for updates.
  Map<String, dynamic> _modelToUpdateMap(CategoryModel model) {
    final map = <String, dynamic>{
      'name': model.name,
      'type': model.type,
      'isDefault': model.isDefault,
      'isActive': model.isActive,
      'order': model.order,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Only include optional fields if they have values
    if (model.icon != null) map['icon'] = model.icon;
    if (model.color != null) map['color'] = model.color;
    if (model.description != null) map['description'] = model.description;
    if (model.familyId != null) map['familyId'] = model.familyId;
    if (model.parentId != null) map['parentId'] = model.parentId;

    return map;
  }

  /// Creates a map for creating a new category with server timestamps.
  Map<String, dynamic> _createCategoryWithTimestamps(CategoryModel model) {
    return {
      ..._modelToCreateMap(model),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Recursively deletes a category and all its descendants.
  Future<void> _deleteCategoryRecursive(String categoryId) async {
    final docRef = _categoryDocument(categoryId);

    // Get all child categories
    final childQuery = await _categoriesCollection
        .where('parentId', isEqualTo: categoryId)
        .get();

    // Recursively delete each child
    for (final childDoc in childQuery.docs) {
      await _deleteCategoryRecursive(childDoc.id);
    }

    // Delete the current category
    await docRef.delete();
  }

  // ==================== Read Operations ====================

  /// Gets a category by ID.
  Future<CategoryModel> getCategory(String categoryId) {
    return _execute(() async {
      final doc = await _categoryDocument(categoryId).get();
      if (!doc.exists) {
        throw const CategoryNotFoundException('Category not found.');
      }
      return _documentToModel(doc);
    });
  }

  /// Gets all categories for a user.
  Future<List<CategoryModel>> getCategoriesByUserId(String userId) {
    return _execute(() async {
      final query = await _categoriesCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('order', descending: false)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets categories by type for a user.
  Future<List<CategoryModel>> getCategoriesByTypeForUser(String userId, String type) {
    return _execute(() async {
      final query = await _categoriesCollection
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type)
          .where('isActive', isEqualTo: true)
          .orderBy('order', descending: false)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets all categories for a family.
  Future<List<CategoryModel>> getCategoriesByFamilyId(String familyId) {
    return _execute(() async {
      final query = await _categoriesCollection
          .where('familyId', isEqualTo: familyId)
          .where('isActive', isEqualTo: true)
          .orderBy('order', descending: false)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets child categories of a parent category.
  Future<List<CategoryModel>> getChildCategories(String parentId) {
    return _execute(() async {
      final query = await _categoriesCollection
          .where('parentId', isEqualTo: parentId)
          .where('isActive', isEqualTo: true)
          .orderBy('order', descending: false)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets root categories (no parent) for a user.
  Future<List<CategoryModel>> getRootCategories(String userId) {
    return _execute(() async {
      final query = await _categoriesCollection
          .where('userId', isEqualTo: userId)
          .where('parentId', isNull: true)
          .where('isActive', isEqualTo: true)
          .orderBy('order', descending: false)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets default categories for a user.
  Future<List<CategoryModel>> getDefaultCategories(String userId) {
    return _execute(() async {
      final query = await _categoriesCollection
          .where('userId', isEqualTo: userId)
          .where('isDefault', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .orderBy('order', descending: false)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  // ==================== Write Operations ====================

  /// Creates a new category.
  Future<CategoryModel> createCategory(CategoryModel category) {
    return _execute(() async {
      final docRef = _categoriesCollection.doc();
      final newCategory = category.copyWith(
        id: docRef.id,
      );

      await docRef.set(_createCategoryWithTimestamps(newCategory));

      // Get the created document with server timestamps
      final doc = await docRef.get();
      return _documentToModel(doc);
    });
  }

  /// Updates an existing category.
  Future<CategoryModel> updateCategory(CategoryModel category) {
    return _execute(() async {
      final docRef = _categoryDocument(category.id);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const CategoryNotFoundException('Category not found.');
      }

      await docRef.update(_modelToUpdateMap(category));

      // Get the updated document with server timestamps
      final updatedDoc = await docRef.get();
      return _documentToModel(updatedDoc);
    });
  }

  /// Deletes a category (soft delete).
  Future<void> deleteCategory(String categoryId) {
    return _execute(() async {
      final docRef = _categoryDocument(categoryId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const CategoryNotFoundException('Category not found.');
      }

      // Soft delete - mark as inactive
      await docRef.update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Permanently deletes a category and all its descendants.
  Future<void> deleteCategoryPermanent(String categoryId) {
    return _execute(() async {
      final docRef = _categoryDocument(categoryId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const CategoryNotFoundException('Category not found.');
      }

      // Recursively delete the category and all children
      await _deleteCategoryRecursive(categoryId);
    });
  }

  /// Reorders categories.
  Future<void> reorderCategories(List<String> categoryIds) {
    return _execute(() async {
      final batch = _firestore.batch();

      for (var i = 0; i < categoryIds.length; i++) {
        final docRef = _categoryDocument(categoryIds[i]);
        batch.update(docRef, {
          'order': i,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    });
  }

  /// Creates default categories for a new user.
  Future<List<CategoryModel>> createDefaultCategories(
    String userId,
    List<CategoryModel> defaultCategories,
  ) async {
    return _execute(() async {
      final batch = _firestore.batch();
      final docRefs = <DocumentReference<Map<String, dynamic>>>[];

      for (var i = 0; i < defaultCategories.length; i++) {
        final category = defaultCategories[i];
        final docRef = _categoriesCollection.doc();
        final newCategory = category.copyWith(
          id: docRef.id,
          userId: userId,
          isDefault: true,
          order: i,
        );

        batch.set(
          docRef,
          _createCategoryWithTimestamps(newCategory),
        );

        docRefs.add(docRef);
      }

      await batch.commit();

      // Fetch the created documents to get server timestamps
      final fetchedCategories = <CategoryModel>[];
      for (final docRef in docRefs) {
        final doc = await docRef.get();
        fetchedCategories.add(_documentToModel(doc));
      }

      return fetchedCategories;
    });
  }

  // ==================== Stream Operations ====================

  /// Watches a category in real-time.
  Stream<CategoryModel> watchCategory(String categoryId) {
    return _executeStream(
      () => _categoryDocument(categoryId).snapshots().map((doc) {
        if (!doc.exists) {
          throw const CategoryNotFoundException('Category not found.');
        }
        return _documentToModel(doc);
      }),
    );
  }

  /// Watches all categories for a user in real-time.
  Stream<List<CategoryModel>> watchCategoriesByUserId(String userId) {
    return _executeStream(
      () => _categoriesCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('order', descending: false)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches categories by type for a specific user in real-time.
  Stream<List<CategoryModel>> watchCategoriesByTypeForUser(String userId, String type) {
    return _executeStream(
      () => _categoriesCollection
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type)
          .where('isActive', isEqualTo: true)
          .orderBy('order', descending: false)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches all categories for a family in real-time.
  Stream<List<CategoryModel>> watchCategoriesByFamilyId(String familyId) {
    return _executeStream(
      () => _categoriesCollection
          .where('familyId', isEqualTo: familyId)
          .where('isActive', isEqualTo: true)
          .orderBy('order', descending: false)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches child categories of a parent in real-time.
  Stream<List<CategoryModel>> watchChildCategories(String parentId) {
    return _executeStream(
      () => _categoriesCollection
          .where('parentId', isEqualTo: parentId)
          .where('isActive', isEqualTo: true)
          .orderBy('order', descending: false)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches root categories for a user in real-time.
  Stream<List<CategoryModel>> watchRootCategories(String userId) {
    return _executeStream(
      () => _categoriesCollection
          .where('userId', isEqualTo: userId)
          .where('parentId', isNull: true)
          .where('isActive', isEqualTo: true)
          .orderBy('order', descending: false)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches default categories for a user in real-time.
  Stream<List<CategoryModel>> watchDefaultCategories(String userId) {
    return _executeStream(
      () => _categoriesCollection
          .where('userId', isEqualTo: userId)
          .where('isDefault', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .orderBy('order', descending: false)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }
}
