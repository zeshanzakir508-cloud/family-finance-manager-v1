// lib/presentation/widgets/buttons/enums/app_button_shape.dart

/// The shape/border radius of the button.
///
/// Each shape corresponds to a specific border radius value
/// defined in the button constants.
enum AppButtonShape {
  /// Rounded corners (8px radius) - default for most buttons.
  rounded,

  /// Pill shape (50px radius) - fully rounded ends.
  pill,

  /// Square corners (0px radius) - sharp edges.
  square,

  /// Circular shape - for icon buttons and FABs.
  circular,
}
