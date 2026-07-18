// lib/data/repositories/account_repository_impl.dart

import '../../domain/repositories/account_repository.dart';
import '../../domain/entities/account.dart';
import '../../domain/exceptions/account_exceptions.dart';
import '../datasources/remote/firestore_account_data_source.dart';
import '../models/account_model.dart';

/// Implementation of [AccountRepository] that coordinates between domain and data layers.
///
/// This class delegates all data operations to the appropriate data sources
/// and converts between domain entities and data models.
///
/// This class MUST NOT contain any Firestore query logic, validation, UI code, or Riverpod code.
class AccountRepositoryImpl implements AccountRepository {
  final FirestoreAccountDataSource _remoteDataSource;

  const AccountRepositoryImpl({
    required FirestoreAccountDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  /// Executes a repository operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on AccountException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const AccountDataException('Unexpected repository error.'),
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
    } on AccountException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const AccountDataException('Unexpected repository stream error.'),
        stackTrace,
      );
    }
  }

  @override
  Future<Account> getAccount(String accountId) {
    return _execute(() async {
      final model = await _remoteDataSource.getAccount(accountId);
      return model.toDomain();
    });
  }

  @override
  Future<List<Account>> getAccountsByUserId(String userId) {
    return _execute(() async {
      final models = await _remoteDataSource.getAccountsByUserId(userId);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<Account> createAccount(Account account) {
    return _execute(() async {
      final model = AccountModel.fromDomain(account);
      final createdModel = await _remoteDataSource.createAccount(model);
      return createdModel.toDomain();
    });
  }

  @override
  Future<Account> updateAccount(Account account) {
    return _execute(() async {
      final model = AccountModel.fromDomain(account);
      final updatedModel = await _remoteDataSource.updateAccount(model);
      return updatedModel.toDomain();
    });
  }

  @override
  Future<void> deleteAccount(String accountId) {
    return _execute(() async {
      await _remoteDataSource.deleteAccount(accountId);
    });
  }

  @override
  Stream<Account> watchAccount(String accountId) {
    return _executeStream(
      () => _remoteDataSource.watchAccount(accountId).map(
            (model) => model.toDomain(),
          ),
    );
  }

  @override
  Stream<List<Account>> watchAccountsByUserId(String userId) {
    return _executeStream(
      () => _remoteDataSource.watchAccountsByUserId(userId).map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }
}
