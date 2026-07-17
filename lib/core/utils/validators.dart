import 'package:flutter/material.dart';

/// ============================================================================
/// Family Finance Manager
/// Validators
/// ----------------------------------------------------------------------------
/// Centralized form validators.
/// Always use these validators instead of writing validation logic in widgets.
/// ============================================================================

class Validators {
  Validators._();

  //--------------------------------------------------------------------------
  // Required
  //--------------------------------------------------------------------------

  static String? required(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  //--------------------------------------------------------------------------
  // Email
  //--------------------------------------------------------------------------

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }

    final emailRegex = RegExp(
      r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  //--------------------------------------------------------------------------
  // Password
  //--------------------------------------------------------------------------

  static String? password(
    String? value, {
    int minLength = 8,
  }) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters.';
    }

    return null;
  }

  //--------------------------------------------------------------------------
  // Confirm Password
  //--------------------------------------------------------------------------

  static String? confirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }

    if (value != originalPassword) {
      return 'Passwords do not match.';
    }

    return null;
  }

  //--------------------------------------------------------------------------
  // Name
  //--------------------------------------------------------------------------

  static String? name(
    String? value, {
    String fieldName = 'Name',
    int minLength = 2,
    int maxLength = 50,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }

    if (value.trim().length < minLength) {
      return '$fieldName must contain at least $minLength characters.';
    }

    if (value.trim().length > maxLength) {
      return '$fieldName cannot exceed $maxLength characters.';
    }

    return null;
  }

  //--------------------------------------------------------------------------
  // Amount
  //--------------------------------------------------------------------------

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required.';
    }

    final amount = double.tryParse(value);

    if (amount == null) {
      return 'Please enter a valid amount.';
    }

    if (amount <= 0) {
      return 'Amount must be greater than zero.';
    }

    return null;
  }

  //--------------------------------------------------------------------------
  // PIN
  //--------------------------------------------------------------------------

  static String? pin(
    String? value, {
    int length = 4,
  }) {
    if (value == null || value.isEmpty) {
      return 'PIN is required.';
    }

    if (value.length != length) {
      return 'PIN must contain exactly $length digits.';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'PIN must contain only digits.';
    }

    return null;
  }

  //--------------------------------------------------------------------------
  // Phone
  //--------------------------------------------------------------------------

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }

    final phoneRegex = RegExp(r'^[0-9+\-\s]{7,20}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number.';
    }

    return null;
  }
}
