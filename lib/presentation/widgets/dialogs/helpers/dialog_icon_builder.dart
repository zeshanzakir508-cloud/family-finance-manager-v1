import 'package:flutter/material.dart';

import '../enums/dialog_type.dart';

/// Builds the appropriate icon for a dialog based on its [DialogType].
///
/// This helper centralizes dialog icon selection to keep dialog widgets
/// clean and consistent throughout the application.
final class DialogIconBuilder {
  const DialogIconBuilder._();

  /// Returns the icon corresponding to the given [DialogType].
  static IconData build(DialogType type) {
    switch (type) {
      case DialogType.info:
        return Icons.info_outline;

      case DialogType.success:
        return Icons.check_circle_outline;

      case DialogType.warning:
        return Icons.warning_amber_rounded;

      case DialogType.error:
        return Icons.error_outline;

      case DialogType.confirmation:
        return Icons.help_outline;
    }
  }
}
