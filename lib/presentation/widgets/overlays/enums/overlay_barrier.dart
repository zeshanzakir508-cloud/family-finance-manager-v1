// lib/presentation/widgets/overlays/enums/overlay_barrier.dart

/// The barrier behavior of the overlay.
enum OverlayBarrier {
  /// Transparent barrier (no dimming).
  transparent,

  /// Semi-transparent barrier (dims background).
  dim,

  /// Opaque barrier (blocks all interaction).
  opaque,

  /// No barrier (interaction allowed outside).
  none,
}
