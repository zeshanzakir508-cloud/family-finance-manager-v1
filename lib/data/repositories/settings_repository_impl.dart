// lib/data/repositories/settings_repository_impl.dart

import '../../domain/repositories/settings_repository.dart';
import '../../domain/entities/settings.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/exceptions/settings_exceptions.dart';
import '../datasources/remote/firestore_settings_data_source.dart';
import '../models/settings_model.dart';
import '../models/user_preferences_model.dart';

/// Implementation of [SettingsRepository] that coordinates between domain and data layers.
///
/// This class delegates all data operations to the appropriate data sources
/// and converts between domain entities and data models.
///
/// This class MUST NOT contain any Firestore query logic, validation, UI code, or Riverpod code.
class SettingsRepositoryImpl implements SettingsRepository {
  final FirestoreSettingsDataSource _remoteDataSource;

  const SettingsRepositoryImpl({
    required FirestoreSettingsDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  /// Executes a repository operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on SettingsException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const SettingsDataException('Unexpected repository error.'),
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
    } on SettingsException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const SettingsDataException('Unexpected repository stream error.'),
        stackTrace,
      );
    }
  }

  @override
  Future<Settings> getSettings(String userId) {
    return _execute(() async {
      final model = await _remoteDataSource.getSettings(userId);
      return model.toDomain();
    });
  }

  @override
  Future<Settings> updateSettings(Settings settings) {
    return _execute(() async {
      final model = SettingsModel.fromDomain(settings);
      final updatedModel = await _remoteDataSource.updateSettings(model);
      return updatedModel.toDomain();
    });
  }

  @override
  Future<Settings> createSettings(Settings settings) {
    return _execute(() async {
      final model = SettingsModel.fromDomain(settings);
      final createdModel = await _remoteDataSource.createSettings(model);
      return createdModel.toDomain();
    });
  }

  @override
  Future<void> deleteSettings(String userId) {
    return _execute(() async {
      await _remoteDataSource.deleteSettings(userId);
    });
  }

  @override
  Future<Settings> updateThemePreference(String userId, ThemePreference theme) {
    return _execute(() async {
      final model = await _remoteDataSource.updateThemePreference(userId, theme);
      return model.toDomain();
    });
  }

  @override
  Future<Settings> updateLanguagePreference(String userId, LanguagePreference language) {
    return _execute(() async {
      final model = await _remoteDataSource.updateLanguagePreference(userId, language);
      return model.toDomain();
    });
  }

  @override
  Future<Settings> updateCurrencyPreference(String userId, CurrencyPreference currency) {
    return _execute(() async {
      final model = await _remoteDataSource.updateCurrencyPreference(userId, currency);
      return model.toDomain();
    });
  }

  @override
  Future<Settings> updateNotificationPreferences(
    String userId,
    NotificationPreferences notifications,
  ) {
    return _execute(() async {
      final model = await _remoteDataSource.updateNotificationPreferences(
        userId,
        notifications,
      );
      return model.toDomain();
    });
  }

  @override
  Future<Settings> updatePrivacyPreferences(
    String userId,
    PrivacyPreferences privacy,
  ) {
    return _execute(() async {
      final model = await _remoteDataSource.updatePrivacyPreferences(userId, privacy);
      return model.toDomain();
    });
  }

  @override
  Future<Settings> updateSecurityPreferences(
    String userId,
    SecurityPreferences security,
  ) {
    return _execute(() async {
      final model = await _remoteDataSource.updateSecurityPreferences(userId, security);
      return model.toDomain();
    });
  }

  @override
  Future<UserPreferences> getUserPreferences(String userId) {
    return _execute(() async {
      final model = await _remoteDataSource.getUserPreferences(userId);
      return model.toDomain();
    });
  }

  @override
  Future<UserPreferences> updateUserPreferences(UserPreferences preferences) {
    return _execute(() async {
      final model = UserPreferencesModel.fromDomain(preferences);
      final updatedModel = await _remoteDataSource.updateUserPreferences(model);
      return updatedModel.toDomain();
    });
  }

  @override
  Future<Settings> getDefaultSettings() {
    return _execute(() async {
      final model = await _remoteDataSource.getDefaultSettings();
      return model.toDomain();
    });
  }

  @override
  Future<void> resetToDefault(String userId) {
    return _execute(() async {
      await _remoteDataSource.resetToDefault(userId);
    });
  }

  @override
  Future<void> exportSettings(String userId, String exportPath) {
    return _execute(() async {
      await _remoteDataSource.exportSettings(userId, exportPath);
    });
  }

  @override
  Future<void> importSettings(String userId, String importPath) {
    return _execute(() async {
      await _remoteDataSource.importSettings(userId, importPath);
    });
  }

  @override
  Stream<Settings> watchSettings(String userId) {
    return _executeStream(
      () => _remoteDataSource.watchSettings(userId).map(
            (model) => model.toDomain(),
          ),
    );
  }

  @override
  Stream<UserPreferences> watchUserPreferences(String userId) {
    return _executeStream(
      () => _remoteDataSource.watchUserPreferences(userId).map(
            (model) => model.toDomain(),
          ),
    );
  }
}
