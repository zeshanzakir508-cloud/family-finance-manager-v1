// lib/presentation/fonts/font_size.dart

/// Enum representing font size preferences.
enum FontSize {
  /// Small font size.
  small,

  /// Medium font size (default).
  medium,

  /// Large font size (accessibility).
  large,
}

/// Extension methods for [FontSize].
extension FontSizeExtension on FontSize {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [FontSize] from a stored string value.
  static FontSize fromValue(String value) {
    return FontSize.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FontSize.medium,
    );
  }

  /// Returns whether this is a small font size.
  bool get isSmall => this == FontSize.small;

  /// Returns whether this is a medium font size.
  bool get isMedium => this == FontSize.medium;

  /// Returns whether this is a large font size.
  bool get isLarge => this == FontSize.large;
}
