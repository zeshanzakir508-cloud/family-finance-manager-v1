// lib/data/datasources/remote/firestore_account_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/exceptions/account_exceptions.dart';
import '../../models/account_model.dart';

/// Data source for Firestore Account operations.
///
/// This class handles all direct communication with Firestore for account-related
/// operations and converts Firestore results to models. It is the only layer that
/// should contain Firestore query logic for accounts.
///
/// This class MUST NOT contain any business logic, validation, UI code, or Riverpod code.
class FirestoreAccountDataSource {
  final FirebaseFirestore _firestore;

  FirestoreAccountDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  /// Collection reference for accounts.
  CollectionReference<Map<String, dynamic>> get _accountsCollection =>
      _firestore.collection('accounts');

  /// Document reference for a specific account.
  DocumentReference<Map<String, dynamic>> _accountDocument(String accountId) =>
      _accountsCollection.doc(accountId);

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
        const AccountDataException('Unexpected account data source error.'),
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
        const AccountDataException('Unexpected account stream error.'),
        stackTrace,
      );
    }
  }

  /// Converts FirestoreException to domain AccountException.
  AccountException _handleFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const AccountDataException('Permission denied to access account data.');
      case 'not-found':
        return const AccountNotFoundException('Account not found.');
      case 'already-exists':
        return const AccountDataException('Account already exists.');
      case 'failed-precondition':
        return const AccountDataException('Precondition failed for account operation.');
      case 'aborted':
        return const AccountDataException('Account operation was aborted.');
      case 'out-of-range':
        return const AccountDataException('Account operation out of range.');
      case 'unimplemented':
        return const AccountDataException('Account operation not implemented.');
      case 'internal':
        return const AccountDataException('Internal error accessing account data.');
      case 'unavailable':
        return const AccountDataException('Account service is temporarily unavailable.');
      case 'deadline-exceeded':
        return const AccountDataException('Account operation timed out.');
      default:
        return AccountDataException('Account error: ${e.message ?? 'Unknown error'}');
    }
  }

  /// Converts Firestore DocumentSnapshot to AccountModel.
  AccountModel _documentToModel(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const AccountDataException('Account document data is null.');
    }

    return AccountModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      type: data['type'] as String? ?? '',
      balance: (data['balance'] as num?)?.toDouble() ?? 0.0,
      currency: data['currency'] as String? ?? 'USD',
      isDefault: data['isDefault'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
      icon: data['icon'] as String?,
      color: data['color'] as String?,
      description: data['description'] as String?,
      familyId: data['familyId'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts AccountModel to Firestore map for creation.
  Map<String, dynamic> _modelToCreateMap(AccountModel model) {
    return {
      'userId': model.userId,
      'name': model.name,
      'type': model.type,
      'balance': model.balance,
      'currency': model.currency,
      'isDefault': model.isDefault,
      'isActive': model.isActive,
      'icon': model.icon,
      'color': model.color,
      'description': model.description,
      'familyId': model.familyId,
    };
  }

  /// Converts AccountModel to Firestore map for updates.
  Map<String, dynamic> _modelToUpdateMap(AccountModel model) {
    final map = <String, dynamic>{
      'name': model.name,
      'type': model.type,
      'balance': model.balance,
      'currency': model.currency,
      'isDefault': model.isDefault,
      'isActive': model.isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Only include optional fields if they have values
    if (model.icon != null) map['icon'] = model.icon;
    if (model.color != null) map['color'] = model.color;
    if (model.description != null) map['description'] = model.description;
    if (model.familyId != null) map['familyId'] = model.familyId;

    return map;
  }

  /// Creates a map for creating a new account with server timestamps.
  Map<String, dynamic> _createAccountWithTimestamps(AccountModel model) {
    return {
      ..._modelToCreateMap(model),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // ==================== Read Operations ====================

  /// Gets an account by ID.
  Future<AccountModel> getAccount(String accountId) {
    return _execute(() async {
      final doc = await _accountDocument(accountId).get();
      if (!doc.exists) {
        throw const AccountNotFoundException('Account not found.');
      }
      return _documentToModel(doc);
    });
  }

  /// Gets all accounts for a user.
  Future<List<AccountModel>> getAccountsByUserId(String userId) {
    return _execute(() async {
      final query = await _accountsCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets all accounts for a family.
  Future<List<AccountModel>> getAccountsByFamilyId(String familyId) {
    return _execute(() async {
      final query = await _accountsCollection
          .where('familyId', isEqualTo: familyId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map(_documentToModel).toList();
    });
  }

  /// Gets default account for a user.
  Future<AccountModel> getDefaultAccount(String userId) {
    return _execute(() async {
      final query = await _accountsCollection
          .where('userId', isEqualTo: userId)
          .where('isDefault', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw const AccountNotFoundException('Default account not found.');
      }

      return _documentToModel(query.docs.first);
    });
  }

  // ==================== Write Operations ====================

  /// Creates a new account.
  Future<AccountModel> createAccount(AccountModel account) {
    return _execute(() async {
      final docRef = _accountsCollection.doc();
      final newAccount = account.copyWith(
        id: docRef.id,
      );

      await docRef.set(_createAccountWithTimestamps(newAccount));

      // Get the created document with server timestamps
      final doc = await docRef.get();
      return _documentToModel(doc);
    });
  }

  /// Updates an existing account.
  Future<AccountModel> updateAccount(AccountModel account) {
    return _execute(() async {
      final docRef = _accountDocument(account.id);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const AccountNotFoundException('Account not found.');
      }

      await docRef.update(_modelToUpdateMap(account));

      // Get the updated document with server timestamps
      final updatedDoc = await docRef.get();
      return _documentToModel(updatedDoc);
    });
  }

  /// Deletes an account (soft delete).
  Future<void> deleteAccount(String accountId) {
    return _execute(() async {
      final docRef = _accountDocument(accountId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const AccountNotFoundException('Account not found.');
      }

      // Soft delete - mark as inactive
      await docRef.update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Permanently deletes an account.
  Future<void> deleteAccountPermanent(String accountId) {
    return _execute(() async {
      final docRef = _accountDocument(accountId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const AccountNotFoundException('Account not found.');
      }

      await docRef.delete();
    });
  }

  /// Updates account balance using a transaction.
  Future<void> updateBalance(String accountId, double newBalance) {
    return _execute(() async {
      final docRef = _accountDocument(accountId);

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw const AccountNotFoundException('Account not found.');
        }

        transaction.update(docRef, {
          'balance': newBalance,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    });
  }

  /// Sets default account for a user.
  Future<void> setDefaultAccount(String userId, String accountId) {
    return _execute(() async {
      final batch = _firestore.batch();

      // First, remove default from all accounts of this user
      final query = await _accountsCollection
          .where('userId', isEqualTo: userId)
          .where('isDefault', isEqualTo: true)
          .get();

      for (final doc in query.docs) {
        batch.update(doc.reference, {
          'isDefault': false,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Then set the new default
      final docRef = _accountDocument(accountId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const AccountNotFoundException('Account not found.');
      }

      batch.update(docRef, {
        'isDefault': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    });
  }

  // ==================== Stream Operations ====================

  /// Watches an account in real-time.
  Stream<AccountModel> watchAccount(String accountId) {
    return _executeStream(
      () => _accountDocument(accountId).snapshots().map((doc) {
        if (!doc.exists) {
          throw const AccountNotFoundException('Account not found.');
        }
        return _documentToModel(doc);
      }),
    );
  }

  /// Watches all accounts for a user in real-time.
  Stream<List<AccountModel>> watchAccountsByUserId(String userId) {
    return _executeStream(
      () => _accountsCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches all accounts for a family in real-time.
  Stream<List<AccountModel>> watchAccountsByFamilyId(String familyId) {
    return _executeStream(
      () => _accountsCollection
          .where('familyId', isEqualTo: familyId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToModel).toList()),
    );
  }

  /// Watches default account for a user in real-time.
  Stream<AccountModel> watchDefaultAccount(String userId) {
    return _executeStream(
      () => _accountsCollection
          .where('userId', isEqualTo: userId)
          .where('isDefault', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .snapshots()
          .map((query) {
            if (query.docs.isEmpty) {
              throw const AccountNotFoundException('Default account not found.');
            }
            return _documentToModel(query.docs.first);
          }),
    );
  }

  /// Watches account balance in real-time.
  Stream<double> watchAccountBalance(String accountId) {
    return _executeStream(
      () => _accountDocument(accountId).snapshots().map((doc) {
        if (!doc.exists) {
          throw const AccountNotFoundException('Account not found.');
        }
        final data = doc.data();
        if (data == null) {
          throw const AccountDataException('Account data is null.');
        }
        return (data['balance'] as num?)?.toDouble() ?? 0.0;
      }),
    );
  }

  /// Gets total balance for a user.
  Future<double> getTotalBalance(String userId) {
    return _execute(() async {
      final query = await _accountsCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      return query.docs.fold<double>(
        0.0,
        (sum, doc) {
          final data = doc.data();
          return sum + ((data['balance'] as num?)?.toDouble() ?? 0.0);
        },
      );
    });
  }

  /// Watches total balance for a user in real-time.
  Stream<double> watchTotalBalance(String userId) {
    return _executeStream(
      () => _accountsCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((query) => query.docs.fold<double>(
                0.0,
                (sum, doc) {
                  final data = doc.data();
                  return sum + ((data['balance'] as num?)?.toDouble() ?? 0.0);
                },
              )),
    );
  }
}
