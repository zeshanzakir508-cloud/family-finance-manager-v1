// lib/presentation/theme/theme_preference.dart

/// Enum representing user theme preferences.
enum ThemePreference {
  /// Light theme.
  light,

  /// Dark theme.
  dark,

  /// System theme (follows device settings).
  system,
}

/// Extension methods for [ThemePreference].
extension ThemePreferenceExtension on ThemePreference {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [ThemePreference] from a stored string value.
  static ThemePreference fromValue(String value) {
    return ThemePreference.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemePreference.system,
    );
  }

  /// Returns whether this is a light theme.
  bool get isLight => this == ThemePreference.light;

  /// Returns whether this is a dark theme.
  bool get isDark => this == ThemePreference.dark;

  /// Returns whether this is a system theme.
  bool get isSystem => this == ThemePreference.system;
}
