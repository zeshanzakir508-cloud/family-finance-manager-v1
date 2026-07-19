/// Defines the elevation level of an [AppCard].
///
/// Elevation controls the visual depth of the card by applying different
/// shadow levels.
///
/// Example:
/// ```dart
/// AppCard(
///   elevation: CardElevation.medium,
/// )
/// ```
enum CardElevation {
  /// No elevation.
  none,

  /// Low elevation, suitable for subtle separation.
  low,

  /// Medium elevation for standard cards.
  medium,

  /// High elevation for prominent cards.
  high,
}
