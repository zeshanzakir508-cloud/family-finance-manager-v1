/// Defines the size of an application app bar.
///
/// Used by [AppBarStyleBuilder] to determine toolbar height,
/// icon size, and spacing.
enum AppBarSize {
  /// Compact app bar.
  compact,

  /// Default app bar.
  medium,

  /// Large app bar.
  large;

  /// Default toolbar height for this app bar size.
  double get toolbarHeight {
    switch (this) {
      case AppBarSize.compact:
        return 48;
      case AppBarSize.medium:
        return 56;
      case AppBarSize.large:
        return 64;
    }
  }
}
