/// Defines the visual appearance of an application app bar.
///
/// Used by [AppBarStyleBuilder] to determine colors, borders,
/// elevation, and overall Material 3 styling.
///
/// Example:
/// ```dart
/// AppBarVariant.filled
/// AppBarVariant.outlined
/// ```
enum AppBarVariant {
  /// A standard filled app bar using the surface color.
  ///
  /// Suitable for most application screens.
  filled,

  /// An app bar with a border and transparent/surface background.
  ///
  /// Useful for settings, forms, and desktop layouts.
  outlined,

  /// An app bar using a tonal container color.
  ///
  /// Matches Material 3 tonal surfaces.
  tonal,

  /// A transparent app bar.
  ///
  /// Typically used with hero images, slivers,
  /// onboarding pages, and immersive layouts.
  transparent,
}
