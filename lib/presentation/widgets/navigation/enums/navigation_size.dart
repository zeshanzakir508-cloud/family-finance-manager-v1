// lib/presentation/widgets/navigation/enums/navigation_size.dart

/// The size of the navigation component.
enum NavigationSize {
  /// Compact size (48px height for bars, 56px width for rail).
  compact,

  /// Medium size (56px height for bars, 72px width for rail).
  medium,

  /// Large size (64px height for bars, 80px width for rail).
  large;

  /// Returns the height for bottom navigation bars.
  double get barHeight {
    switch (this) {
      case NavigationSize.compact:
        return 48;
      case NavigationSize.medium:
        return 56;
      case NavigationSize.large:
        return 64;
    }
  }

  /// Returns the width for navigation rails.
  double get railWidth {
    switch (this) {
      case NavigationSize.compact:
        return 56;
      case NavigationSize.medium:
        return 72;
      case NavigationSize.large:
        return 80;
    }
  }
}
