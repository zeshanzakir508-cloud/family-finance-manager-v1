// lib/presentation/widgets/dialogs/helpers/dialog_icon_builder.dart

import 'package:flutter/material.dart';

import '../enums/dialog_type.dart';

/// Helper class for mapping [DialogType] to [IconData].
///
/// Example:
/// ```dart
/// final iconData = DialogIconBuilder.build(DialogType.success);
/// ```
abstract final class DialogIconBuilder {
  /// Returns the appropriate [IconData] for the given [type].
  static IconData build(DialogType type) {
    switch (type) {
      case DialogType.success:
        return Icons.check_circle;
      case DialogType.info:
        return Icons.info;
      case DialogType.warning:
        return Icons.warning;
      case DialogType.error:
        return Icons.error;
      case DialogType.confirmation:
        return Icons.help;
    }
  }
}
