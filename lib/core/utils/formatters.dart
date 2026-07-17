import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// ============================================================================
/// Family Finance Manager
/// Formatters
/// ----------------------------------------------------------------------------
/// Centralized formatting utilities.
///
/// NOTE:
/// Requires the `intl` package.
/// ============================================================================

class Formatters {
  Formatters._();

  //--------------------------------------------------------------------------
  // Currency
  //--------------------------------------------------------------------------

  static String currency(
    num value, {
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      symbol: AppConstants.currencySymbol,
      decimalDigits: decimalDigits,
    );

    return formatter.format(value);
  }

  //--------------------------------------------------------------------------
  // Number
  //--------------------------------------------------------------------------

  static String number(
    num value, {
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.decimalPattern();

    if (decimalDigits == 0) {
      return formatter.format(value.round());
    }

    return value.toStringAsFixed(decimalDigits);
  }

  //--------------------------------------------------------------------------
  // Percentage
  //--------------------------------------------------------------------------

  static String percentage(
    num value, {
    int decimalDigits = 1,
  }) {
    return '${value.toStringAsFixed(decimalDigits)}%';
  }

  //--------------------------------------------------------------------------
  // Date
  //--------------------------------------------------------------------------

  static String date(
    DateTime date, {
    String pattern = 'dd MMM yyyy',
  }) {
    return DateFormat(pattern).format(date);
  }

  //--------------------------------------------------------------------------
  // Time
  //--------------------------------------------------------------------------

  static String time(
    DateTime dateTime, {
    String pattern = 'hh:mm a',
  }) {
    return DateFormat(pattern).format(dateTime);
  }

  //--------------------------------------------------------------------------
  // Date & Time
  //--------------------------------------------------------------------------

  static String dateTime(
    DateTime dateTime, {
    String pattern = 'dd MMM yyyy • hh:mm a',
  }) {
    return DateFormat(pattern).format(dateTime);
  }

  //--------------------------------------------------------------------------
  // Month & Year
  //--------------------------------------------------------------------------

  static String monthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  //--------------------------------------------------------------------------
  // Short Date
  //--------------------------------------------------------------------------

  static String shortDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  //--------------------------------------------------------------------------
  // File Timestamp
  //--------------------------------------------------------------------------

  static String fileTimestamp(DateTime dateTime) {
    return DateFormat('yyyyMMdd_HHmmss').format(dateTime);
  }
}
