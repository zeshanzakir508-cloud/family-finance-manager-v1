// lib/presentation/widgets/media/enums/image_placeholder.dart

/// The type of placeholder to display while loading.
enum ImagePlaceholder {
  /// No placeholder.
  none,

  /// A shimmer effect placeholder.
  shimmer,

  /// A blurred version of the image.
  blur,

  /// A solid color placeholder.
  color,

  /// A circular progress indicator.
  progress,

  /// A custom widget.
  custom,
}
