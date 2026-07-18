// lib/presentation/icons/category_icon.dart

/// Enum representing category icons.
enum CategoryIcon {
  /// Food and dining.
  food,

  /// Transportation.
  transport,

  /// Shopping.
  shopping,

  /// Entertainment.
  entertainment,

  /// Healthcare.
  healthcare,

  /// Education.
  education,

  /// Housing.
  housing,

  /// Utilities.
  utilities,

  /// Insurance.
  insurance,

  /// Salary.
  salary,

  /// Freelance.
  freelance,

  /// Investment.
  investment,

  /// Gift.
  gift,

  /// Other.
  other,
}

/// Extension methods for [CategoryIcon].
extension CategoryIconExtension on CategoryIcon {
  /// String representation used for storage and serialization.
  String get value => name;

  /// Creates a [CategoryIcon] from a stored string value.
  static CategoryIcon fromValue(String value) {
    return CategoryIcon.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CategoryIcon.other,
    );
  }
}
