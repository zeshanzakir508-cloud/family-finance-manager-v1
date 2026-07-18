// lib/data/repositories/transaction_repository_impl.dart

import '../../domain/repositories/transaction_repository.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/exceptions/transaction_exceptions.dart';
import '../datasources/remote/firestore_transaction_data_source.dart';
import '../models/transaction_model.dart';

/// Implementation of [TransactionRepository] that coordinates between domain and data layers.
///
/// This class delegates all data operations to the appropriate data sources
/// and converts between domain entities and data models.
///
/// This class MUST NOT contain any Firestore query logic, validation, UI code, or Riverpod code.
class TransactionRepositoryImpl implements TransactionRepository {
  final FirestoreTransactionDataSource _remoteDataSource;

  const TransactionRepositoryImpl({
    required FirestoreTransactionDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  /// Executes a repository operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on TransactionException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const TransactionDataException('Unexpected repository error.'),
        stackTrace,
      );
    }
  }

  /// Executes a stream repository operation with consistent error handling.
  Stream<T> _executeStream<T>(
    Stream<T> Function() action,
  ) async* {
    try {
      await for (final value in action()) {
        yield value;
      }
    } on TransactionException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const TransactionDataException('Unexpected repository stream error.'),
        stackTrace,
      );
    }
  }

  @override
  Future<Transaction> getTransaction(String transactionId) {
    return _execute(() async {
      final model = await _remoteDataSource.getTransaction(transactionId);
      return model.toDomain();
    });
  }

  @override
  Future<List<Transaction>> getTransactionsByUserId(String userId) {
    return _execute(() async {
      final models = await _remoteDataSource.getTransactionsByUserId(userId);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Transaction>> getTransactionsByAccountId(String accountId) {
    return _execute(() async {
      final models = await _remoteDataSource.getTransactionsByAccountId(accountId);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Transaction>> getTransactionsByCategoryId(String categoryId) {
    return _execute(() async {
      final models = await _remoteDataSource.getTransactionsByCategoryId(categoryId);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _execute(() async {
      final models = await _remoteDataSource.getTransactionsByDateRange(
        startDate,
        endDate,
      );
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<List<Transaction>> getTransactionsByFamilyId(String familyId) {
    return _execute(() async {
      final models = await _remoteDataSource.getTransactionsByFamilyId(familyId);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<Transaction> createTransaction(Transaction transaction) {
    return _execute(() async {
      final model = TransactionModel.fromDomain(transaction);
      final createdModel = await _remoteDataSource.createTransaction(model);
      return createdModel.toDomain();
    });
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) {
    return _execute(() async {
      final model = TransactionModel.fromDomain(transaction);
      final updatedModel = await _remoteDataSource.updateTransaction(model);
      return updatedModel.toDomain();
    });
  }

  @override
  Future<void> deleteTransaction(String transactionId) {
    return _execute(() async {
      await _remoteDataSource.deleteTransaction(transactionId);
    });
  }

  @override
  Future<double> getTotalByCategory(String categoryId, DateTime startDate, DateTime endDate) {
    return _execute(() async {
      return await _remoteDataSource.getTotalByCategory(categoryId, startDate, endDate);
    });
  }

  @override
  Future<double> getTotalByAccount(String accountId, DateTime startDate, DateTime endDate) {
    return _execute(() async {
      return await _remoteDataSource.getTotalByAccount(accountId, startDate, endDate);
    });
  }

  @override
  Future<Map<CategoryType, double>> getSummaryByType(String userId, DateTime startDate, DateTime endDate) {
    return _execute(() async {
      return await _remoteDataSource.getSummaryByType(userId, startDate, endDate);
    });
  }

  @override
  Stream<Transaction> watchTransaction(String transactionId) {
    return _executeStream(
      () => _remoteDataSource.watchTransaction(transactionId).map(
            (model) => model.toDomain(),
          ),
    );
  }

  @override
  Stream<List<Transaction>> watchTransactionsByUserId(String userId) {
    return _executeStream(
      () => _remoteDataSource.watchTransactionsByUserId(userId).map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }

  @override
  Stream<List<Transaction>> watchTransactionsByAccountId(String accountId) {
    return _executeStream(
      () => _remoteDataSource.watchTransactionsByAccountId(accountId).map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }

  @override
  Stream<List<Transaction>> watchTransactionsByCategoryId(String categoryId) {
    return _executeStream(
      () => _remoteDataSource.watchTransactionsByCategoryId(categoryId).map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }

  @override
  Stream<List<Transaction>> watchTransactionsByFamilyId(String familyId) {
    return _executeStream(
      () => _remoteDataSource.watchTransactionsByFamilyId(familyId).map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }

  @override
  Stream<double> watchTotalByCategory(String categoryId, DateTime startDate, DateTime endDate) {
    return _executeStream(
      () => _remoteDataSource.watchTotalByCategory(categoryId, startDate, endDate),
    );
  }

  @override
  Stream<double> watchTotalByAccount(String accountId, DateTime startDate, DateTime endDate) {
    return _executeStream(
      () => _remoteDataSource.watchTotalByAccount(accountId, startDate, endDate),
    );
  }
}
