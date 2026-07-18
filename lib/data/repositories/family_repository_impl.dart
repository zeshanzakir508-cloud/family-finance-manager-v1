// lib/data/repositories/family_repository_impl.dart

import '../../domain/repositories/family_repository.dart';
import '../../domain/entities/family.dart';
import '../../domain/entities/family_member.dart';
import '../../domain/exceptions/family_exceptions.dart';
import '../datasources/remote/firestore_family_data_source.dart';
import '../models/family_model.dart';
import '../models/family_member_model.dart';

/// Implementation of [FamilyRepository] that coordinates between domain and data layers.
///
/// This class delegates all data operations to the appropriate data sources
/// and converts between domain entities and data models.
///
/// This class MUST NOT contain any Firestore query logic, validation, UI code, or Riverpod code.
class FamilyRepositoryImpl implements FamilyRepository {
  final FirestoreFamilyDataSource _remoteDataSource;

  const FamilyRepositoryImpl({
    required FirestoreFamilyDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  /// Executes a repository operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on FamilyException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const FamilyDataException('Unexpected repository error.'),
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
    } on FamilyException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const FamilyDataException('Unexpected repository stream error.'),
        stackTrace,
      );
    }
  }

  @override
  Future<Family> getFamily(String familyId) {
    return _execute(() async {
      final model = await _remoteDataSource.getFamily(familyId);
      return model.toDomain();
    });
  }

  @override
  Future<List<Family>> getFamiliesByUserId(String userId) {
    return _execute(() async {
      final models = await _remoteDataSource.getFamiliesByUserId(userId);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<Family> createFamily(Family family) {
    return _execute(() async {
      final model = FamilyModel.fromDomain(family);
      final createdModel = await _remoteDataSource.createFamily(model);
      return createdModel.toDomain();
    });
  }

  @override
  Future<Family> updateFamily(Family family) {
    return _execute(() async {
      final model = FamilyModel.fromDomain(family);
      final updatedModel = await _remoteDataSource.updateFamily(model);
      return updatedModel.toDomain();
    });
  }

  @override
  Future<void> deleteFamily(String familyId) {
    return _execute(() async {
      await _remoteDataSource.deleteFamily(familyId);
    });
  }

  @override
  Future<FamilyMember> addFamilyMember(FamilyMember member) {
    return _execute(() async {
      final model = FamilyMemberModel.fromDomain(member);
      final createdModel = await _remoteDataSource.addFamilyMember(model);
      return createdModel.toDomain();
    });
  }

  @override
  Future<FamilyMember> updateFamilyMember(FamilyMember member) {
    return _execute(() async {
      final model = FamilyMemberModel.fromDomain(member);
      final updatedModel = await _remoteDataSource.updateFamilyMember(model);
      return updatedModel.toDomain();
    });
  }

  @override
  Future<void> removeFamilyMember(String familyId, String userId) {
    return _execute(() async {
      await _remoteDataSource.removeFamilyMember(familyId, userId);
    });
  }

  @override
  Future<List<FamilyMember>> getFamilyMembers(String familyId) {
    return _execute(() async {
      final models = await _remoteDataSource.getFamilyMembers(familyId);
      return models.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<FamilyMember> getFamilyMember(String familyId, String userId) {
    return _execute(() async {
      final model = await _remoteDataSource.getFamilyMember(familyId, userId);
      return model.toDomain();
    });
  }

  @override
  Future<bool> isUserInFamily(String familyId, String userId) {
    return _execute(() async {
      return await _remoteDataSource.isUserInFamily(familyId, userId);
    });
  }

  @override
  Future<void> updateFamilyMemberRole(String familyId, String userId, FamilyMemberRole role) {
    return _execute(() async {
      await _remoteDataSource.updateFamilyMemberRole(familyId, userId, role);
    });
  }

  @override
  Future<void> updateFamilyMemberPermissions(String familyId, String userId, Map<String, bool> permissions) {
    return _execute(() async {
      await _remoteDataSource.updateFamilyMemberPermissions(familyId, userId, permissions);
    });
  }

  @override
  Stream<Family> watchFamily(String familyId) {
    return _executeStream(
      () => _remoteDataSource.watchFamily(familyId).map(
            (model) => model.toDomain(),
          ),
    );
  }

  @override
  Stream<List<Family>> watchFamiliesByUserId(String userId) {
    return _executeStream(
      () => _remoteDataSource.watchFamiliesByUserId(userId).map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }

  @override
  Stream<List<FamilyMember>> watchFamilyMembers(String familyId) {
    return _executeStream(
      () => _remoteDataSource.watchFamilyMembers(familyId).map(
            (models) => models.map((model) => model.toDomain()).toList(),
          ),
    );
  }

  @override
  Stream<FamilyMember> watchFamilyMember(String familyId, String userId) {
    return _executeStream(
      () => _remoteDataSource.watchFamilyMember(familyId, userId).map(
            (model) => model.toDomain(),
          ),
    );
  }
}
