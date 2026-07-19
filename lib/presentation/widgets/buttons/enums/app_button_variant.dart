// lib/presentation/widgets/buttons/enums/app_button_variant.dart

/// The visual variant of the button.
///
/// Each variant corresponds to a specific Material Design 3 button style
/// and visual treatment.
enum AppButtonVariant {
  /// Primary filled button - uses the primary color from the theme.
  primary,

  /// Secondary filled button - uses the secondary color from the theme.
  secondary,

  /// Tonal button - uses a tonal variation of the primary color.
  tonal,

  /// Outlined button - has a border with transparent background.
  outlined,

  /// Text-only button - no background or border, just text.
  text,

  /// Danger button - uses error color for destructive actions.
  danger,

  /// Success button - uses success color for positive actions.
  success,
}
