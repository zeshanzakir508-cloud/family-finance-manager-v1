// lib/presentation/widgets/animations/enums/animation_speed.dart

/// Predefined animation speeds for consistent timing.
enum AnimationSpeed {
  /// Instant (0ms).
  instant,

  /// Very fast (100ms).
  veryFast,

  /// Fast (200ms).
  fast,

  /// Normal (300ms).
  normal,

  /// Slow (500ms).
  slow,

  /// Very slow (800ms).
  verySlow,

  /// Custom duration (use with customDuration).
  custom;

  /// Returns the duration in milliseconds for this speed.
  Duration get duration {
    switch (this) {
      case AnimationSpeed.instant:
        return Duration.zero;
      case AnimationSpeed.veryFast:
        return const Duration(milliseconds: 100);
      case AnimationSpeed.fast:
        return const Duration(milliseconds: 200);
      case AnimationSpeed.normal:
        return const Duration(milliseconds: 300);
      case AnimationSpeed.slow:
        return const Duration(milliseconds: 500);
      case AnimationSpeed.verySlow:
        return const Duration(milliseconds: 800);
      case AnimationSpeed.custom:
        return const Duration(milliseconds: 400);
    }
  }
}
