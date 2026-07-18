// lib/repositories/implementations/budget_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../interfaces/budget_repository.dart';
import '../interfaces/base_repository.dart';
import '../../services/firestore_service.dart';
import '../../constants/firestore_constants.dart';
import '../../models/budget_model.dart';
import '../../exceptions/app_exception.dart';
import '../../exceptions/firestore_exception.dart';

/// Implementation of BudgetRepository that handles all budget-related Firestore operations.
///
/// This repository follows the single responsibility principle and only handles
/// data persistence. All business logic should be in domain managers/use cases.
///
/// Budgets track spending limits for categories over specific time periods (monthly,
/// weekly, yearly, etc.). The repository provides methods to create, update, and
/// query budgets, as well as track spending progress against budget limits.
class BudgetRepositoryImpl extends BaseRepository implements BudgetRepository {
  BudgetRepositoryImpl({
    required FirestoreService firestoreService,
  }) : super(firestoreService);

  @override
  String get collectionPath => FirestoreConstants.budgets;

  // ==================== Private Helpers ====================

  /// Updates a subset of budget fields while maintaining version consistency.
  Future<void> _updateFields(
    String budgetId,
    Map<String, dynamic> fields,
  ) async {
    try {
      final budget = await getBudget(budgetId);
      if (budget == null) {
        throw AppException('Budget not found: $budgetId');
      }

      final now = DateTime.now();
      final updateData = {
        ...fields,
        FirestoreConstants.updatedAt: now,
        FirestoreConstants.version: budget.version + 1,
      };

      await updateDocument(budgetId, updateData);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update budget fields for $budgetId: ${e.toString()}');
    }
  }

  /// Updates budget spending using a transaction for atomicity.
  ///
  /// Why: Spending updates require atomic read-modify-write operations to prevent
  /// race conditions when multiple transactions update the same budget
  /// simultaneously. Using a transaction ensures the spending is always consistent.
  Future<void> _updateSpending({
    required String budgetId,
    required double amount,
    required bool isIncrement,
  }) async {
    try {
      final docRef = getDocumentReference(budgetId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Budget not found: $budgetId');
        }

        final data = doc.data()!;
        final currentSpent = (data[FirestoreConstants.spent] as num?)?.toDouble() ?? 0;
        final currentVersion = data[FirestoreConstants.version] as int? ?? 0;
        
        final newSpent = isIncrement
            ? currentSpent + amount
            : currentSpent - amount;
        
        // Prevent negative spending
        final finalSpent = newSpent < 0 ? 0 : newSpent;
        
        final now = DateTime.now();
        
        final updateData = {
          FirestoreConstants.spent: finalSpent,
          FirestoreConstants.updatedAt: now,
          FirestoreConstants.version: currentVersion + 1,
        };
        
        transaction.update(docRef, updateData);
      });
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update spending for budget $budgetId: ${e.toString()}');
    }
  }

  /// Resets budget spending using a transaction for atomicity.
  ///
  /// Why: Like spending updates, resetting spending should be atomic to prevent
  /// race conditions with concurrent modifications.
  Future<void> _resetSpending(String budgetId) async {
    try {
      final docRef = getDocumentReference(budgetId);
      
      await runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw AppException('Budget not found: $budgetId');
        }

        final currentVersion = doc.data()?[FirestoreConstants.version] as int? ?? 0;
        final now = DateTime.now();
        
        final updateData = {
          FirestoreConstants.spent: 0,
          FirestoreConstants.updatedAt: now,
          FirestoreConstants.version: currentVersion + 1,
        };
        
        transaction.update(docRef, updateData);
      });
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to reset spending for budget $budgetId: ${e.toString()}');
    }
  }

  /// Builds a query with common budget filters.
  Query _buildBudgetQuery({
    required String familyId,
    String? categoryId,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
    bool includeDeleted = false,
  }) {
    final collection = firestoreService.collection(collectionPath);
    Query query = collection
        .where(FirestoreConstants.familyId, isEqualTo: familyId);

    if (!includeDeleted) {
      query = query.where(FirestoreConstants.isDeleted, isEqualTo: false);
    }

    if (categoryId != null) {
      query = query.where(FirestoreConstants.categoryId, isEqualTo: categoryId);
    }

    if (period != null) {
      query = query.where(FirestoreConstants.period, isEqualTo: period);
    }

    if (startDate != null) {
      query = query.where(
        FirestoreConstants.startDate,
        isGreaterThanOrEqualTo: startDate,
      );
    }

    if (endDate != null) {
      query = query.where(
        FirestoreConstants.endDate,
        isLessThanOrEqualTo: endDate,
      );
    }

    return query;
  }

  // ==================== Public Methods ====================

  @override
  Future<void> createBudget(BudgetModel budget) async {
    try {
      final now = DateTime.now();
      
      final newBudget = budget.copyWith(
        version: 1,
        createdAt: now,
        updatedAt: now,
        spent: 0, // Always start with zero spending
      );
      
      await setDocument(
        budget.id,
        newBudget.toJson(),
      );
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to create budget ${budget.id}: ${e.toString()}');
    }
  }

  @override
  Future<BudgetModel?> getBudget(String budgetId) async {
    try {
      final doc = await getDocument(budgetId);
      if (!doc.exists) return null;
      return BudgetModel.fromJson(doc.data()!);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get budget $budgetId: ${e.toString()}');
    }
  }

  @override
  Stream<BudgetModel?> watchBudget(String budgetId) {
    return watchDocument(budgetId).map((doc) {
      if (!doc.exists) return null;
      return BudgetModel.fromJson(doc.data()!);
    });
  }

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    try {
      final existing = await getBudget(budget.id);
      if (existing == null) {
        throw AppException('Budget not found: ${budget.id}');
      }

      final now = DateTime.now();
      final updatedBudget = budget.copyWith(
        updatedAt: now,
        version: existing.version + 1,
      );
      
      await updateDocument(budget.id, updatedBudget.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to update budget ${budget.id}: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteBudget(String budgetId) async {
    try {
      final budget = await getBudget(budgetId);
      if (budget == null) {
        throw AppException('Budget not found: $budgetId');
      }

      final now = DateTime.now();
      final updatedBudget = budget.copyWith(
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
        version: budget.version + 1,
      );
      
      await updateDocument(budgetId, updatedBudget.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to delete budget $budgetId: ${e.toString()}');
    }
  }

  @override
  Future<void> restoreBudget(String budgetId) async {
    try {
      final budget = await getBudget(budgetId);
      if (budget == null) {
        throw AppException('Budget not found: $budgetId');
      }

      final now = DateTime.now();
      final updatedBudget = budget.copyWith(
        isDeleted: false,
        deletedAt: null,
        updatedAt: now,
        version: budget.version + 1,
      );
      
      await updateDocument(budgetId, updatedBudget.toJson());
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to restore budget $budgetId: ${e.toString()}');
    }
  }

  @override
  Future<bool> budgetExists(String budgetId) async {
    try {
      return await documentExists(budgetId);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to check budget existence for $budgetId: ${e.toString()}');
    }
  }

  // ==================== Query Methods ====================

  @override
  Future<List<BudgetModel>> getBudgetsByFamily({
    required String familyId,
    bool includeDeleted = false,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _buildBudgetQuery(
        familyId: familyId,
        includeDeleted: includeDeleted,
      );

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final docs = await query
          .orderBy(FirestoreConstants.startDate, descending: true)
          .limit(limit)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => BudgetModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get budgets for family $familyId: ${e.toString()}');
    }
  }

  @override
  Future<List<BudgetModel>> getBudgetsByCategory({
    required String categoryId,
    required String familyId,
    bool includeDeleted = false,
  }) async {
    try {
      final query = _buildBudgetQuery(
        familyId: familyId,
        categoryId: categoryId,
        includeDeleted: includeDeleted,
      );

      final docs = await query
          .orderBy(FirestoreConstants.startDate, descending: true)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => BudgetModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get budgets for category $categoryId: ${e.toString()}');
    }
  }

  @override
  Future<List<BudgetModel>> getActiveBudgets({
    required String familyId,
    required DateTime date,
    bool includeDeleted = false,
  }) async {
    try {
      final query = _buildBudgetQuery(
        familyId: familyId,
        includeDeleted: includeDeleted,
      );

      final docs = await query
          .where(
            FirestoreConstants.startDate,
            isLessThanOrEqualTo: date,
          )
          .where(
            FirestoreConstants.endDate,
            isGreaterThanOrEqualTo: date,
          )
          .orderBy(FirestoreConstants.startDate, descending: true)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => BudgetModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get active budgets for family $familyId: ${e.toString()}');
    }
  }

  @override
  Future<List<BudgetModel>> getBudgetsByPeriod({
    required String familyId,
    required String period,
    bool includeDeleted = false,
  }) async {
    try {
      final query = _buildBudgetQuery(
        familyId: familyId,
        period: period,
        includeDeleted: includeDeleted,
      );

      final docs = await query
          .orderBy(FirestoreConstants.startDate, descending: true)
          .get();

      return docs.docs
          .where((doc) => doc.exists)
          .map((doc) => BudgetModel.fromJson(doc.data()))
          .toList();
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get budgets for period $period: ${e.toString()}');
    }
  }

  @override
  Future<BudgetModel?> getBudgetForCategory({
    required String familyId,
    required String categoryId,
    required DateTime date,
  }) async {
    try {
      final budgets = await getActiveBudgets(
        familyId: familyId,
        date: date,
      );

      // Find the budget for the specific category
      for (final budget in budgets) {
        if (budget.categoryId == categoryId) {
          return budget;
        }
      }
      return null;
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to get budget for category $categoryId: ${e.toString()}');
    }
  }

  @override
  Stream<List<BudgetModel>> watchBudgetsByFamily({
    required String familyId,
    bool includeDeleted = false,
  }) {
    try {
      final query = _buildBudgetQuery(
        familyId: familyId,
        includeDeleted: includeDeleted,
      ).orderBy(FirestoreConstants.startDate, descending: true);

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .where((doc) => doc.exists)
            .map((doc) => BudgetModel.fromJson(doc.data()))
            .toList();
      });
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to watch budgets for family $familyId: ${e.toString()}');
    }
  }

  // ==================== Budget Management Methods ====================

  @override
  Future<void> addSpending({
    required String budgetId,
    required double amount,
  }) async {
    await _updateSpending(
      budgetId: budgetId,
      amount: amount,
      isIncrement: true,
    );
  }

  @override
  Future<void> removeSpending({
    required String budgetId,
    required double amount,
  }) async {
    await _updateSpending(
      budgetId: budgetId,
      amount: amount,
      isIncrement: false,
    );
  }

  @override
  Future<void> resetSpending(String budgetId) async {
    await _resetSpending(budgetId);
  }

  @override
  Future<void> updateBudgetLimit({
    required String budgetId,
    required double newLimit,
  }) async {
    await _updateFields(
      budgetId,
      {FirestoreConstants.limit: newLimit},
    );
  }

  @override
  Future<void> updateBudgetPeriod({
    required String budgetId,
    required String newPeriod,
  }) async {
    await _updateFields(
      budgetId,
      {FirestoreConstants.period: newPeriod},
    );
  }

  @override
  Future<void> updateBudgetDates({
    required String budgetId,
    required DateTime newStartDate,
    required DateTime newEndDate,
  }) async {
    await _updateFields(
      budgetId,
      {
        FirestoreConstants.startDate: newStartDate,
        FirestoreConstants.endDate: newEndDate,
      },
    );
  }

  @override
  Future<void> copyBudgetToPeriod({
    required String budgetId,
    required DateTime newStartDate,
    required DateTime newEndDate,
  }) async {
    try {
      final existing = await getBudget(budgetId);
      if (existing == null) {
        throw AppException('Budget not found: $budgetId');
      }

      final now = DateTime.now();
      
      // Generate a new ID for the copied budget
      final newId = firestoreService.collection(collectionPath).doc().id;
      
      final newBudget = existing.copyWith(
        id: newId,
        startDate: newStartDate,
        endDate: newEndDate,
        spent: 0,
        version: 1,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
        deletedAt: null,
      );

      await createBudget(newBudget);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException.fromFirebaseException(e);
    } catch (e) {
      throw AppException('Failed to copy budget $budgetId: ${e.toString()}');
    }
  }
}
