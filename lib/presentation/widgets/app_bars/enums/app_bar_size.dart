/// Defines the size of an application app bar.
///
/// The selected size determines the toolbar height and
/// spacing used by [AppBarStyleBuilder].
///
/// Example:
/// ```dart
/// AppBarSize.compact
/// AppBarSize.medium
/// AppBarSize.large
/// ```
enum AppBarSize {
  /// A compact app bar.
  ///
  /// Recommended for dense layouts, desktop interfaces,
  /// and secondary pages.
  compact,

  /// A standard app bar.
  ///
  /// This is the default size and should be used for
  /// most application screens.
  medium,

  /// A large app bar.
  ///
  /// Suitable for dashboards, home screens,
  /// and pages requiring greater visual emphasis.
  large,
}
