// lib/data/datasources/remote/firestore_transaction_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/exceptions/transaction_exceptions.dart';
import '../../models/transaction_model.dart';

/// Data source for Firestore Transaction operations.
///
/// This class handles all direct communication with Firestore for transaction-related
/// operations and converts Firestore results to models. It is the only layer that
/// should contain Firestore query logic for transactions.
///
/// This class MUST NOT contain any business logic, validation, UI code, or Riverpod code.
class FirestoreTransactionDataSource {
  final FirebaseFirestore _firestore;

  FirestoreTransactionDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  /// Collection reference for transactions.
  CollectionReference<Map<String, dynamic>> get _transactionsCollection =>
      _firestore.collection('transactions');

  /// Document reference for a specific transaction.
  DocumentReference<Map<String, dynamic>> _transactionDocument(String transactionId) =>
      _transactionsCollection.doc(transactionId);

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
        const TransactionDataException('Unexpected transaction data source error.'),
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
        const TransactionDataException('Unexpected transaction stream error.'),
        stackTrace,
      );
    }
  }

  /// Converts FirestoreException to domain TransactionException.
  TransactionException _handleFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const TransactionDataException('Permission denied to access transaction data.');
      case 'not-found':
        return const TransactionNotFoundException('Transaction not found.');
      case 'already-exists':
        return const TransactionDataException('Transaction already exists.');
      case 'failed-precondition':
        return const TransactionDataException('Precondition failed for transaction operation.');
      case 'aborted':
        return const TransactionDataException('Transaction operation was aborted.');
      case 'out-of-range':
        return const TransactionDataException('Transaction operation out of range.');
      case 'unimplemented':
        return const TransactionDataException('Transaction operation not implemented.');
      case 'internal':
        return const TransactionDataException('Internal error accessing transaction data.');
      case 'unavailable':
        return const TransactionDataException('Transaction service is temporarily unavailable.');
      case 'deadline-exceeded':
        return const TransactionDataException('Transaction operation timed out.');
      default:
        return TransactionDataException('Transaction error: ${e.message ?? 'Unknown error'}');
    }
  }

  /// Converts Firestore DocumentSnapshot to TransactionModel.
  TransactionModel _documentToModel(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const TransactionDataException('Transaction document data is null.');
    }

    final date = (data['date'] as Timestamp?)?.toDate();
    if (date == null) {
      throw const TransactionDataException('Transaction date is required.');
    }

    return TransactionModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      accountId: data['accountId'] as String? ?? '',
      categoryId: data['categoryId'] as String? ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] as String? ?? '',
      type: data['type'] as String? ?? '',
      date: date,
      isRecurring: data['isRecurring'] as bool? ?? false,
      recurringType: data['recurringType'] as String?,
      recurringInterval: data['recurringInterval'] as int?,
      parentTransactionId: data['parentTransactionId'] as String?,
      familyId: data['familyId'] as String?,
      isSplit: data['isSplit'] as bool? ?? false,
      splitTransactions: (data['splitTransactions'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      attachments: (data['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (data['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      notes: data['notes'] as String?,
      location: data['location'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts TransactionModel to Firestore map for creation.
  Map<String, dynamic> _modelToCreateMap(TransactionModel model) {
    return {
      'userId': model.userId,
      'accountId': model.accountId,
      'categoryId': model.categoryId,
      'amount': model.amount,
      'description': model.description,
      'type': model.type,
      'date': model.date,
      'isRecurring': model.isRecurring,
      'recurringType': model.recurringType,
      'recurringInterval': model.recurringInterval,
      'parentTransactionId': model.parentTransactionId,
      'familyId': model.familyId,
      'isSplit': model.isSplit,
      'splitTransactions': model.splitTransactions,
      'attachments': model.attachments,
      'tags': model.tags,
      'notes': model.notes,
      'location': model.location,
    };
  }

  /// Converts TransactionModel to Firestore map for updates.
  Map<String, dynamic> _modelToUpdateMap(TransactionModel model) {
    final map = <String, dynamic>{
      'accountId': model.accountId,
      'categoryId': model.categoryId,
      'amount': model.amount,
      'description': model.description,
      'type': model.type,
      'date': model.date,
      'isRecurring': model.isRecurring,
      'isSplit': model.isSplit,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Only include optional fields if they have values
    if (model.recurringType != null) map['recurringType'] = model.recurringType;
    if (model.recurringInterval != null) map['recurringInterval'] = model.recurringInterval;
    if (model.parentTransactionId != null) map['parentTransactionId'] = model.parentTransactionId;
    if (model.familyId != null) map['familyId'] = model.familyId;
    if (model.splitTransactions != null) map['splitTransactions'] = model.splitTransactions;
    if (model.attachments != null) map['attachments'] = model.attachments;
    if (model.tags != null) map['tags'] = model.tags;
    if (model.notes != null) map['notes'] = model.notes;
    if (model.location != null) map['location'] = model.location;

    return map;
  }

  /// Creates a map for creating a new transaction with server timestamps.
  Map<String, dynamic> _createTransactionWithTimestamps(TransactionModel model) {
    return {
      ..._modelToCreateMap(model),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Builds the split transaction data for the parent.
  List<Map<String, dynamic>> _buildSplitData(List<TransactionModel> splits) {
    return splits.map((t) => {
          'amount': t.amount,
          'categoryId': t.categoryId,
          'description': t.description,
        }).toList();
  }

  /// Creates a child split transaction.
  TransactionModel _createChildSplitTransaction(
    TransactionModel split,
    String parentId,
    String userId,
    String accountId,
    DateTime date,
    String type,
    String? familyId,
  ) {
    return split.copyWith(
      id: '',
      parentTransactionId: parentId,
      userId: userId,
      accountId: accountId,
      date: date,
      type: type,
      familyId: familyId,
    );
  }

  // ==================== Read Operations ====================

  /// Gets a transaction by ID.
  Future<TransactionModel> getTransaction(String transactionId) {
    return _execute(() async {
      final doc = await _transactionDocument(transactionId).get();
      if (!doc.exists) {
        throw const TransactionNotFoundException('Transaction not found.');
      }
      return _documentToModel(doc);
    });
  }

  /// Gets all transactions for a user.
  Future<List<TransactionModel>> getTransactionsByUserId(String userId) {
    return _execute(() async {
      final query = await _transactionsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets transactions by account ID.
  Future<List<TransactionModel>> getTransactionsByAccountId(String accountId) {
    return _execute(() async {
      final query = await _transactionsCollection
          .where('accountId', isEqualTo: accountId)
          .orderBy('date', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets transactions by category ID.
  Future<List<TransactionModel>> getTransactionsByCategoryId(String categoryId) {
    return _execute(() async {
      final query = await _transactionsCollection
          .where('categoryId', isEqualTo: categoryId)
          .orderBy('date', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets transactions by date range.
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _execute(() async {
      final query = await _transactionsCollection
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .orderBy('date', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets transactions by user and date range.
  Future<List<TransactionModel>> getTransactionsByUserAndDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _execute(() async {
      final query = await _transactionsCollection
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .orderBy('date', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets transactions by family ID.
  Future<List<TransactionModel>> getTransactionsByFamilyId(String familyId) {
    return _execute(() async {
      final query = await _transactionsCollection
          .where('familyId', isEqualTo: familyId)
          .orderBy('date', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets recurring transactions.
  Future<List<TransactionModel>> getRecurringTransactions(String userId) {
    return _execute(() async {
      final query = await _transactionsCollection
          .where('userId', isEqualTo: userId)
          .where('isRecurring', isEqualTo: true)
          .orderBy('date', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  // ==================== Write Operations ====================

  /// Creates a new transaction.
  Future<TransactionModel> createTransaction(TransactionModel transaction) {
    return _execute(() async {
      final docRef = _transactionsCollection.doc();
      final newTransaction = transaction.copyWith(
        id: docRef.id,
      );

      await docRef.set(_createTransactionWithTimestamps(newTransaction));

      // Get the created document with server timestamps
      final doc = await docRef.get();
      return _documentToModel(doc);
    });
  }

  /// Updates an existing transaction.
  Future<TransactionModel> updateTransaction(TransactionModel transaction) {
    return _execute(() async {
      final docRef = _transactionDocument(transaction.id);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const TransactionNotFoundException('Transaction not found.');
      }

      await docRef.update(_modelToUpdateMap(transaction));

      // Get the updated document with server timestamps
      final updatedDoc = await docRef.get();
      return _documentToModel(updatedDoc);
    });
  }

  /// Permanently deletes a transaction.
  Future<void> deleteTransaction(String transactionId) {
    return _execute(() async {
      final docRef = _transactionDocument(transactionId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const TransactionNotFoundException('Transaction not found.');
      }

      // Also delete any split transactions
      final splitQuery = await _transactionsCollection
          .where('parentTransactionId', isEqualTo: transactionId)
          .get();

      final batch = _firestore.batch();

      // Delete parent
      batch.delete(docRef);

      // Delete all split transactions
      for (final splitDoc in splitQuery.docs) {
        batch.delete(splitDoc.reference);
      }

      await batch.commit();
    });
  }

  /// Creates a split transaction with multiple sub-transactions.
  Future<List<TransactionModel>> createSplitTransaction(
    TransactionModel parentTransaction,
    List<TransactionModel> splitTransactions,
  ) async {
    return _execute(() async {
      final batch = _firestore.batch();
      final splitRefs = <DocumentReference<Map<String, dynamic>>>[];

      // Create parent transaction
      final parentDocRef = _transactionsCollection.doc();
      final parentWithId = parentTransaction.copyWith(
        id: parentDocRef.id,
        isSplit: true,
        splitTransactions: _buildSplitData(splitTransactions),
      );

      batch.set(
        parentDocRef,
        _createTransactionWithTimestamps(parentWithId),
      );

      // Create split transactions
      for (final split in splitTransactions) {
        final splitDocRef = _transactionsCollection.doc();
        final splitWithId = _createChildSplitTransaction(
          split,
          parentDocRef.id,
          parentTransaction.userId,
          parentTransaction.accountId,
          parentTransaction.date,
          parentTransaction.type,
          parentTransaction.familyId,
        ).copyWith(id: splitDocRef.id);

        batch.set(
          splitDocRef,
          _createTransactionWithTimestamps(splitWithId),
        );

        splitRefs.add(splitDocRef);
      }

      await batch.commit();

      // Fetch the created documents to get server timestamps
      final parentDoc = await parentDocRef.get();
      final parentModel = _documentToModel(parentDoc);

      // Fetch split transactions
      final fetchedSplits = <TransactionModel>[];
      for (final ref in splitRefs) {
        final doc = await ref.get();
        fetchedSplits.add(_documentToModel(doc));
      }

      return [parentModel, ...fetchedSplits];
    });
  }

  // ==================== Analytics Operations ====================

  /// Gets total by category for a date range.
  Future<double> getTotalByCategory(
    String categoryId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _execute(() async {
      final query = await _transactionsCollection
          .where('categoryId', isEqualTo: categoryId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      return query.docs.fold<double>(
        0.0,
        (sum, doc) {
          final data = doc.data();
          return sum + ((data['amount'] as num?)?.toDouble() ?? 0.0);
        },
      );
    });
  }

  /// Gets total by account for a date range.
  Future<double> getTotalByAccount(
    String accountId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _execute(() async {
      final query = await _transactionsCollection
          .where('accountId', isEqualTo: accountId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      return query.docs.fold<double>(
        0.0,
        (sum, doc) {
          final data = doc.data();
          return sum + ((data['amount'] as num?)?.toDouble() ?? 0.0);
        },
      );
    });
  }

  /// Gets summary by type for a user and date range.
  Future<Map<String, double>> getSummaryByType(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _execute(() async {
      final query = await _transactionsCollection
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      final summary = <String, double>{};

      for (final doc in query.docs) {
        final data = doc.data();
        final type = data['type'] as String? ?? 'expense';
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;

        summary[type] = (summary[type] ?? 0.0) + amount;
      }

      return summary;
    });
  }

  /// Gets monthly summary for a user.
  Future<Map<String, double>> getMonthlySummary(String userId, int year, int month) {
    return _execute(() async {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);

      final query = await _transactionsCollection
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      final summary = <String, double>{};

      for (final doc in query.docs) {
        final data = doc.data();
        final categoryId = data['categoryId'] as String? ?? 'uncategorized';
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;

        summary[categoryId] = (summary[categoryId] ?? 0.0) + amount;
      }

      return summary;
    });
  }

  // ==================== Stream Operations ====================

  /// Watches a transaction in real-time.
  Stream<TransactionModel> watchTransaction(String transactionId) {
    return _executeStream(
      () => _transactionDocument(transactionId).snapshots().map((doc) {
        if (!doc.exists) {
          throw const TransactionNotFoundException('Transaction not found.');
        }
        return _documentToModel(doc);
      }),
    );
  }

  /// Watches all transactions for a user in real-time.
  Stream<List<TransactionModel>> watchTransactionsByUserId(String userId) {
    return _executeStream(
      () => _transactionsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches transactions by account in real-time.
  Stream<List<TransactionModel>> watchTransactionsByAccountId(String accountId) {
    return _executeStream(
      () => _transactionsCollection
          .where('accountId', isEqualTo: accountId)
          .orderBy('date', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches transactions by category in real-time.
  Stream<List<TransactionModel>> watchTransactionsByCategoryId(String categoryId) {
    return _executeStream(
      () => _transactionsCollection
          .where('categoryId', isEqualTo: categoryId)
          .orderBy('date', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches transactions by family in real-time.
  Stream<List<TransactionModel>> watchTransactionsByFamilyId(String familyId) {
    return _executeStream(
      () => _transactionsCollection
          .where('familyId', isEqualTo: familyId)
          .orderBy('date', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches transactions by user and date range in real-time.
  Stream<List<TransactionModel>> watchTransactionsByUserAndDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _executeStream(
      () => _transactionsCollection
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .orderBy('date', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches recurring transactions in real-time.
  Stream<List<TransactionModel>> watchRecurringTransactions(String userId) {
    return _executeStream(
      () => _transactionsCollection
          .where('userId', isEqualTo: userId)
          .where('isRecurring', isEqualTo: true)
          .orderBy('date', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches total by category in real-time.
  Stream<double> watchTotalByCategory(
    String categoryId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _executeStream(
      () => _transactionsCollection
          .where('categoryId', isEqualTo: categoryId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .snapshots()
          .map((query) => query.docs.fold<double>(
                0.0,
                (sum, doc) {
                  final data = doc.data();
                  return sum + ((data['amount'] as num?)?.toDouble() ?? 0.0);
                },
              )),
    );
  }

  /// Watches total by account in real-time.
  Stream<double> watchTotalByAccount(
    String accountId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _executeStream(
      () => _transactionsCollection
          .where('accountId', isEqualTo: accountId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .snapshots()
          .map((query) => query.docs.fold<double>(
                0.0,
                (sum, doc) {
                  final data = doc.data();
                  return sum + ((data['amount'] as num?)?.toDouble() ?? 0.0);
                },
              )),
    );
  }
}
