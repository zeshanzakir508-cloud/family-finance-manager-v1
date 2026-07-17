import '../utils/formatters.dart';

/// ============================================================================
/// Family Finance Manager
/// Number Extensions
/// ----------------------------------------------------------------------------
/// Common helper methods for int, double and num.
/// ============================================================================

extension NumExtensions on num {
  //--------------------------------------------------------------------------
  // State
  //--------------------------------------------------------------------------

  bool get isZero => this == 0;

  bool get isNotZero => this != 0;

  bool get isPositive => this > 0;

  bool get isNegative => this < 0;

  //---------------------------------------------------------------------------
  // Integer Check
  //---------------------------------------------------------------------------

  bool get isWholeNumber => this % 1 == 0;

  //---------------------------------------------------------------------------
  // Absolute
  //---------------------------------------------------------------------------

  num get absolute => abs();

  //---------------------------------------------------------------------------
  // Rounding
  //---------------------------------------------------------------------------

  double roundTo(int decimalPlaces) {
    final factor = pow10(decimalPlaces);
    return (this * factor).round() / factor;
  }

  //---------------------------------------------------------------------------
  // Formatting
  //---------------------------------------------------------------------------

  String toCurrency({
    String symbol = 'Rs.',
    int decimalDigits = 2,
  }) {
    return Formatters.currency(
      this,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
  }

  String toNumber({
    int decimalDigits = 2,
  }) {
    return Formatters.number(
      this,
      decimalDigits: decimalDigits,
    );
  }

  String toPercentage({
    int decimalDigits = 1,
  }) {
    return Formatters.percentage(
      this,
      decimalDigits: decimalDigits,
    );
  }
}

/// ============================================================================
/// Internal Helper
/// ============================================================================

int pow10(int exponent) {
  var result = 1;

  for (var i = 0; i < exponent; i++) {
    result *= 10;
  }

  return result;
}
