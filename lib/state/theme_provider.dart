import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void setTheme(ThemeMode themeMode) {
    state = themeMode;

    // TODO:
    // Persist theme preference.
  }

  void setLightTheme() {
    state = ThemeMode.light;

    // TODO:
    // Persist theme preference.
  }

  void setDarkTheme() {
    state = ThemeMode.dark;

    // TODO:
    // Persist theme preference.
  }

  void setSystemTheme() {
    state = ThemeMode.system;

    // TODO:
    // Persist theme preference.
  }

  Future<void> loadTheme() async {
    // TODO:
    // Load theme preference from local storage.
  }
}
