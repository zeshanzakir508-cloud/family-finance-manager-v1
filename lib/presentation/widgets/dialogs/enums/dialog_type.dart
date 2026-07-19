/// Defines the visual purpose of an application dialog.
///
/// Used to determine the appropriate icon, color, and styling for dialogs.
enum DialogType {
  /// Neutral informational dialog.
  info,

  /// Successful operation.
  success,

  /// Warning that requires user attention.
  warning,

  /// Error or failure.
  error,

  /// Confirmation dialog requiring user action.
  confirmation,
}
