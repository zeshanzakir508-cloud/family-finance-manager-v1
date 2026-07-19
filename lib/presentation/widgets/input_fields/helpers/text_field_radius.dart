import 'package:flutter/material.dart';

import '../constants/text_field_constants.dart';

/// Border radius helper for AppTextField widgets.
abstract final class TextFieldRadius {
  /// Returns the default border radius.
  static BorderRadius get value => TextFieldConstants.borderRadius;
}
