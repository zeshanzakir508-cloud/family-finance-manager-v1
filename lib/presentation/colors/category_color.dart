// lib/presentation/colors/category_color.dart

/// Enum representing category colors.
enum CategoryColor {
  /// Red.
  red,

  /// Pink.
  pink,

  /// Purple.
  purple,

  /// Deep purple.
  deepPurple,

  /// Indigo.
  indigo,

  /// Blue.
  blue,

  /// Light blue.
  lightBlue,

  /// Cyan.
  cyan,

  /// Teal.
  teal,

  /// Green.
  green,

  /// Light green.
  lightGreen,

  /// Lime.
  lime,

  /// Yellow.
  yellow,

  /// Amber.
  amber,

  /// Orange.
  orange,

  /// Deep orange.
  deepOrange,

  /// Brown.
  brown,

  /// Grey.
  grey,

  /// Blue grey.
  blueGrey,
}

/// Extension methods for [CategoryColor].
extension CategoryColorExtension on CategoryColor {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [CategoryColor] from a stored string value.
  static CategoryColor fromValue(String value) {
    return CategoryColor.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CategoryColor.blue,
    );
  }
}
