import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings_model.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<AppSettingsModel?>>(
  (ref) => SettingsNotifier(),
);

class SettingsNotifier
    extends StateNotifier<AsyncValue<AppSettingsModel?>> {
  SettingsNotifier() : super(const AsyncValue.loading());

  Future<void> loadSettings(String familyId) async {
    state = const AsyncValue.loading();

    // TODO:
    // Load app settings from Firestore repository.
  }

  Future<void> refresh() async {
    // TODO:
    // Reload settings.
  }

  Future<void> clear() async {
    state = const AsyncValue.data(null);
  }

  Future<void> updateSettings(AppSettingsModel settings) async {
    state = AsyncValue.data(settings);

    // TODO:
    // Save settings to Firestore repository.
  }
}
