/// ============================================================================
/// Family Finance Manager
/// String Extensions
/// ----------------------------------------------------------------------------
/// Common string helper methods.
/// ============================================================================

extension StringExtensions on String {
  //--------------------------------------------------------------------------
  // Empty Checks
  //--------------------------------------------------------------------------

  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => trim().isNotEmpty;

  //--------------------------------------------------------------------------
  // Capitalization
  //--------------------------------------------------------------------------

  String get capitalize {
    if (trim().isEmpty) return this;

    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get titleCase {
    if (trim().isEmpty) return this;

    return trim()
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return word;

          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        })
        .join(' ');
  }

  //--------------------------------------------------------------------------
  // Whitespace
  //--------------------------------------------------------------------------

  String get removeExtraSpaces {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  //--------------------------------------------------------------------------
  // Initials
  //--------------------------------------------------------------------------

  String get initials {
    final words = removeExtraSpaces.split(' ');

    if (words.isEmpty) return '';

    if (words.length == 1) {
      return words.first[0].toUpperCase();
    }

    return (words.first[0] + words.last[0]).toUpperCase();
  }

  //--------------------------------------------------------------------------
  // Reverse
  //--------------------------------------------------------------------------

  String get reversed {
    return split('').reversed.join();
  }

  //--------------------------------------------------------------------------
  // Numeric Checks
  //--------------------------------------------------------------------------

  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  bool get isInteger {
    return int.tryParse(this) != null;
  }

  //--------------------------------------------------------------------------
  // Safe Parsing
  //--------------------------------------------------------------------------

  int? get toIntOrNull {
    return int.tryParse(this);
  }

  double? get toDoubleOrNull {
    return double.tryParse(this);
  }
}
