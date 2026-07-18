// lib/data/datasources/remote/firestore_settings_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/exceptions/settings_exceptions.dart';
import '../../models/settings_model.dart';
import '../../models/user_preferences_model.dart';

/// Data source for Firestore Settings operations.
///
/// This class handles all direct communication with Firestore for settings-related
/// operations and converts Firestore results to models. It is the only layer that
/// should contain Firestore query logic for settings and user preferences.
///
/// This class MUST NOT contain any business logic, validation, UI code, or Riverpod code.
class FirestoreSettingsDataSource {
  final FirebaseFirestore _firestore;

  FirestoreSettingsDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  /// Collection reference for settings.
  CollectionReference<Map<String, dynamic>> get _settingsCollection =>
      _firestore.collection('settings');

  /// Collection reference for user preferences.
  CollectionReference<Map<String, dynamic>> get _preferencesCollection =>
      _firestore.collection('userPreferences');

  /// Document reference for a specific settings document.
  DocumentReference<Map<String, dynamic>> _settingsDocument(String userId) =>
      _settingsCollection.doc(userId);

  /// Document reference for a specific user preferences document.
  DocumentReference<Map<String, dynamic>> _preferencesDocument(String userId) =>
      _preferencesCollection.doc(userId);

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
        const SettingsDataException('Unexpected settings data source error.'),
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
        const SettingsDataException('Unexpected settings stream error.'),
        stackTrace,
      );
    }
  }

  /// Converts FirestoreException to domain SettingsException.
  SettingsException _handleFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const SettingsDataException('Permission denied to access settings data.');
      case 'not-found':
        return const SettingsNotFoundException('Settings not found.');
      case 'already-exists':
        return const SettingsDataException('Settings already exists.');
      case 'failed-precondition':
        return const SettingsDataException('Precondition failed for settings operation.');
      case 'aborted':
        return const SettingsDataException('Settings operation was aborted.');
      case 'out-of-range':
        return const SettingsDataException('Settings operation out of range.');
      case 'unimplemented':
        return const SettingsDataException('Settings operation not implemented.');
      case 'internal':
        return const SettingsDataException('Internal error accessing settings data.');
      case 'unavailable':
        return const SettingsDataException('Settings service is temporarily unavailable.');
      case 'deadline-exceeded':
        return const SettingsDataException('Settings operation timed out.');
      default:
        return SettingsDataException('Settings error: ${e.message ?? 'Unknown error'}');
    }
  }

  // ==================== Default Settings ====================

  /// Built-in default settings (single source of truth).
  SettingsModel _getBuiltInDefaultSettings() {
    return SettingsModel(
      userId: 'defaults',
      theme: 'system',
      language: 'en',
      currency: 'USD',
      notifications: {
        'email': true,
        'push': true,
        'transactionAlerts': true,
        'familyAlerts': true,
        'weeklyReports': true,
      },
      privacy: {
        'shareData': false,
        'shareAnalytics': false,
        'publicProfile': false,
      },
      security: {
        'biometricEnabled': false,
        'pinEnabled': false,
        'twoFactorEnabled': false,
        'sessionTimeout': 30,
      },
      appearance: {
        'compactMode': false,
        'showBalance': true,
      },
      features: {
        'darkMode': true,
        'budgetTracking': true,
      },
    );
  }

  /// Internal method to get default settings without wrapping in _execute.
  Future<SettingsModel> _getDefaultSettingsInternal() async {
    final doc = await _settingsCollection.doc('defaults').get();

    if (!doc.exists) {
      return _getBuiltInDefaultSettings();
    }

    return _documentToSettingsModel(doc);
  }

  // ==================== Mapping Methods ====================

  /// Converts Firestore DocumentSnapshot to SettingsModel.
  SettingsModel _documentToSettingsModel(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const SettingsDataException('Settings document data is null.');
    }

    return SettingsModel(
      userId: doc.id,
      theme: data['theme'] as String? ?? 'system',
      language: data['language'] as String? ?? 'en',
      currency: data['currency'] as String? ?? 'USD',
      notifications: (data['notifications'] as Map<String, dynamic>?) ?? {},
      privacy: (data['privacy'] as Map<String, dynamic>?) ?? {},
      security: (data['security'] as Map<String, dynamic>?) ?? {},
      appearance: (data['appearance'] as Map<String, dynamic>?) ?? {},
      features: (data['features'] as Map<String, dynamic>?) ?? {},
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts Firestore DocumentSnapshot to UserPreferencesModel.
  UserPreferencesModel _documentToPreferencesModel(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const SettingsDataException('User preferences document data is null.');
    }

    return UserPreferencesModel(
      userId: doc.id,
      defaultAccountId: data['defaultAccountId'] as String?,
      defaultCategoryIds: (data['defaultCategoryIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      defaultFamilyId: data['defaultFamilyId'] as String?,
      dashboardLayout: data['dashboardLayout'] as String? ?? 'default',
      chartPreferences: (data['chartPreferences'] as Map<String, dynamic>?) ?? {},
      recentTransactionsCount: data['recentTransactionsCount'] as int? ?? 10,
      budgetAlertThreshold: data['budgetAlertThreshold'] as double? ?? 80.0,
      weeklyReportDay: data['weeklyReportDay'] as int? ?? 7,
      monthlyReportDay: data['monthlyReportDay'] as int? ?? 1,
      customCategories: (data['customCategories'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts SettingsModel to Firestore map for creation.
  Map<String, dynamic> _settingsToCreateMap(SettingsModel model) {
    return {
      'theme': model.theme,
      'language': model.language,
      'currency': model.currency,
      'notifications': model.notifications,
      'privacy': model.privacy,
      'security': model.security,
      'appearance': model.appearance,
      'features': model.features,
    };
  }

  /// Converts SettingsModel to Firestore map for updates.
  Map<String, dynamic> _settingsToUpdateMap(SettingsModel model) {
    final map = <String, dynamic>{
      'theme': model.theme,
      'language': model.language,
      'currency': model.currency,
      'notifications': model.notifications,
      'privacy': model.privacy,
      'security': model.security,
      'appearance': model.appearance,
      'features': model.features,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    return map;
  }

  /// Creates a map for creating settings with server timestamps.
  Map<String, dynamic> _createSettingsWithTimestamps(SettingsModel model) {
    return {
      ..._settingsToCreateMap(model),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Converts UserPreferencesModel to Firestore map for creation.
  Map<String, dynamic> _preferencesToCreateMap(UserPreferencesModel model) {
    return {
      'defaultAccountId': model.defaultAccountId,
      'defaultCategoryIds': model.defaultCategoryIds,
      'defaultFamilyId': model.defaultFamilyId,
      'dashboardLayout': model.dashboardLayout,
      'chartPreferences': model.chartPreferences,
      'recentTransactionsCount': model.recentTransactionsCount,
      'budgetAlertThreshold': model.budgetAlertThreshold,
      'weeklyReportDay': model.weeklyReportDay,
      'monthlyReportDay': model.monthlyReportDay,
      'customCategories': model.customCategories,
    };
  }

  /// Converts UserPreferencesModel to Firestore map for updates.
  Map<String, dynamic> _preferencesToUpdateMap(UserPreferencesModel model) {
    final map = <String, dynamic>{
      'defaultAccountId': model.defaultAccountId,
      'defaultCategoryIds': model.defaultCategoryIds,
      'defaultFamilyId': model.defaultFamilyId,
      'dashboardLayout': model.dashboardLayout,
      'chartPreferences': model.chartPreferences,
      'recentTransactionsCount': model.recentTransactionsCount,
      'budgetAlertThreshold': model.budgetAlertThreshold,
      'weeklyReportDay': model.weeklyReportDay,
      'monthlyReportDay': model.monthlyReportDay,
      'customCategories': model.customCategories,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    return map;
  }

  /// Creates a map for creating user preferences with server timestamps.
  Map<String, dynamic> _createPreferencesWithTimestamps(UserPreferencesModel model) {
    return {
      ..._preferencesToCreateMap(model),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // ==================== Settings Helper Methods ====================

  /// Internal helper to update settings fields and return the updated model.
  Future<SettingsModel> _updateSettingsFields(
    String userId,
    Map<String, dynamic> updateData,
  ) async {
    final docRef = _settingsDocument(userId);
    final doc = await docRef.get();

    if (!doc.exists) {
      throw const SettingsNotFoundException('Settings not found for user.');
    }

    updateData['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.update(updateData);

    final updatedDoc = await docRef.get();
    return _documentToSettingsModel(updatedDoc);
  }

  /// Internal helper to update preferences fields and return the updated model.
  Future<UserPreferencesModel> _updatePreferencesFields(
    String userId,
    Map<String, dynamic> updateData,
  ) async {
    final docRef = _preferencesDocument(userId);
    final doc = await docRef.get();

    if (!doc.exists) {
      throw const SettingsNotFoundException('User preferences not found.');
    }

    updateData['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.update(updateData);

    final updatedDoc = await docRef.get();
    return _documentToPreferencesModel(updatedDoc);
  }

  // ==================== Settings Operations ====================

  /// Gets settings for a user.
  Future<SettingsModel> getSettings(String userId) {
    return _execute(() async {
      final doc = await _settingsDocument(userId).get();
      if (!doc.exists) {
        throw const SettingsNotFoundException('Settings not found for user.');
      }
      return _documentToSettingsModel(doc);
    });
  }

  /// Creates settings for a user.
  Future<SettingsModel> createSettings(SettingsModel settings) {
    return _execute(() async {
      final docRef = _settingsDocument(settings.userId);

      final doc = await docRef.get();
      if (doc.exists) {
        throw const SettingsDataException('Settings already exist for this user.');
      }

      await docRef.set(_createSettingsWithTimestamps(settings));

      final createdDoc = await docRef.get();
      return _documentToSettingsModel(createdDoc);
    });
  }

  /// Updates settings for a user.
  Future<SettingsModel> updateSettings(SettingsModel settings) {
    return _execute(() async {
      return await _updateSettingsFields(
        settings.userId,
        _settingsToUpdateMap(settings),
      );
    });
  }

  /// Deletes settings for a user.
  Future<void> deleteSettings(String userId) {
    return _execute(() async {
      final docRef = _settingsDocument(userId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const SettingsNotFoundException('Settings not found for user.');
      }

      await docRef.delete();
    });
  }

  /// Updates theme preference.
  Future<SettingsModel> updateThemePreference(String userId, String theme) {
    return _execute(() async {
      return await _updateSettingsFields(
        userId,
        {'theme': theme},
      );
    });
  }

  /// Updates language preference.
  Future<SettingsModel> updateLanguagePreference(String userId, String language) {
    return _execute(() async {
      return await _updateSettingsFields(
        userId,
        {'language': language},
      );
    });
  }

  /// Updates currency preference.
  Future<SettingsModel> updateCurrencyPreference(String userId, String currency) {
    return _execute(() async {
      return await _updateSettingsFields(
        userId,
        {'currency': currency},
      );
    });
  }

  /// Updates notification preferences.
  Future<SettingsModel> updateNotificationPreferences(
    String userId,
    Map<String, dynamic> notifications,
  ) {
    return _execute(() async {
      return await _updateSettingsFields(
        userId,
        {'notifications': notifications},
      );
    });
  }

  /// Updates privacy preferences.
  Future<SettingsModel> updatePrivacyPreferences(
    String userId,
    Map<String, dynamic> privacy,
  ) {
    return _execute(() async {
      return await _updateSettingsFields(
        userId,
        {'privacy': privacy},
      );
    });
  }

  /// Updates security preferences.
  Future<SettingsModel> updateSecurityPreferences(
    String userId,
    Map<String, dynamic> security,
  ) {
    return _execute(() async {
      return await _updateSettingsFields(
        userId,
        {'security': security},
      );
    });
  }

  /// Gets default settings.
  Future<SettingsModel> getDefaultSettings() {
    return _execute(() async {
      return await _getDefaultSettingsInternal();
    });
  }

  /// Resets settings to default.
  Future<void> resetToDefault(String userId) {
    return _execute(() async {
      final defaults = await _getDefaultSettingsInternal();

      final docRef = _settingsDocument(userId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const SettingsNotFoundException('Settings not found for user.');
      }

      await docRef.update({
        'theme': defaults.theme,
        'language': defaults.language,
        'currency': defaults.currency,
        'notifications': defaults.notifications,
        'privacy': defaults.privacy,
        'security': defaults.security,
        'appearance': defaults.appearance,
        'features': defaults.features,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // ==================== User Preferences Operations ====================

  /// Gets user preferences for a user.
  Future<UserPreferencesModel> getUserPreferences(String userId) {
    return _execute(() async {
      final doc = await _preferencesDocument(userId).get();
      if (!doc.exists) {
        throw const SettingsNotFoundException('User preferences not found.');
      }
      return _documentToPreferencesModel(doc);
    });
  }

  /// Creates user preferences for a user.
  Future<UserPreferencesModel> createUserPreferences(UserPreferencesModel preferences) {
    return _execute(() async {
      final docRef = _preferencesDocument(preferences.userId);

      final doc = await docRef.get();
      if (doc.exists) {
        throw const SettingsDataException('User preferences already exist.');
      }

      await docRef.set(_createPreferencesWithTimestamps(preferences));

      final createdDoc = await docRef.get();
      return _documentToPreferencesModel(createdDoc);
    });
  }

  /// Updates user preferences for a user.
  Future<UserPreferencesModel> updateUserPreferences(UserPreferencesModel preferences) {
    return _execute(() async {
      return await _updatePreferencesFields(
        preferences.userId,
        _preferencesToUpdateMap(preferences),
      );
    });
  }

  /// Updates default account preference.
  Future<UserPreferencesModel> updateDefaultAccount(String userId, String? accountId) {
    return _execute(() async {
      final updateData = <String, dynamic>{};
      if (accountId != null) {
        updateData['defaultAccountId'] = accountId;
      } else {
        updateData['defaultAccountId'] = FieldValue.delete();
      }

      return await _updatePreferencesFields(userId, updateData);
    });
  }

  /// Updates default category preferences.
  Future<UserPreferencesModel> updateDefaultCategories(String userId, List<String>? categoryIds) {
    return _execute(() async {
      final updateData = <String, dynamic>{};
      if (categoryIds != null) {
        updateData['defaultCategoryIds'] = categoryIds;
      } else {
        updateData['defaultCategoryIds'] = FieldValue.delete();
      }

      return await _updatePreferencesFields(userId, updateData);
    });
  }

  /// Updates default family preference.
  Future<UserPreferencesModel> updateDefaultFamily(String userId, String? familyId) {
    return _execute(() async {
      final updateData = <String, dynamic>{};
      if (familyId != null) {
        updateData['defaultFamilyId'] = familyId;
      } else {
        updateData['defaultFamilyId'] = FieldValue.delete();
      }

      return await _updatePreferencesFields(userId, updateData);
    });
  }

  /// Updates dashboard layout preference.
  Future<UserPreferencesModel> updateDashboardLayout(String userId, String layout) {
    return _execute(() async {
      return await _updatePreferencesFields(
        userId,
        {'dashboardLayout': layout},
      );
    });
  }

  /// Updates budget alert threshold.
  Future<UserPreferencesModel> updateBudgetAlertThreshold(String userId, double threshold) {
    return _execute(() async {
      return await _updatePreferencesFields(
        userId,
        {'budgetAlertThreshold': threshold},
      );
    });
  }

  /// Updates recent transactions count.
  Future<UserPreferencesModel> updateRecentTransactionsCount(String userId, int count) {
    return _execute(() async {
      return await _updatePreferencesFields(
        userId,
        {'recentTransactionsCount': count},
      );
    });
  }

  /// Updates weekly report day.
  Future<UserPreferencesModel> updateWeeklyReportDay(String userId, int day) {
    return _execute(() async {
      return await _updatePreferencesFields(
        userId,
        {'weeklyReportDay': day},
      );
    });
  }

  /// Updates monthly report day.
  Future<UserPreferencesModel> updateMonthlyReportDay(String userId, int day) {
    return _execute(() async {
      return await _updatePreferencesFields(
        userId,
        {'monthlyReportDay': day},
      );
    });
  }

  // ==================== Stream Operations ====================

  /// Watches settings for a user in real-time.
  Stream<SettingsModel> watchSettings(String userId) {
    return _executeStream(
      () => _settingsDocument(userId).snapshots().map((doc) {
        if (!doc.exists) {
          throw const SettingsNotFoundException('Settings not found for user.');
        }
        return _documentToSettingsModel(doc);
      }),
    );
  }

  /// Watches user preferences in real-time.
  Stream<UserPreferencesModel> watchUserPreferences(String userId) {
    return _executeStream(
      () => _preferencesDocument(userId).snapshots().map((doc) {
        if (!doc.exists) {
          throw const SettingsNotFoundException('User preferences not found.');
        }
        return _documentToPreferencesModel(doc);
      }),
    );
  }
}
