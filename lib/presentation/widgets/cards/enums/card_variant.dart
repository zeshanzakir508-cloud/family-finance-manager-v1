/// Defines the visual appearance of an [AppCard].
///
/// These variants follow Material 3 design principles and provide
/// consistent styling across the application.
///
/// Example:
/// ```dart
/// AppCard(
///   variant: CardVariant.elevated,
/// )
/// ```
enum CardVariant {
  /// A card with a solid background color and no border.
  filled,

  /// A card with a border and transparent background.
  outlined,

  /// A card with elevation (shadow).
  elevated,

  /// A card using the theme's secondary container color.
  tonal,
}
