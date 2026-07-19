// lib/presentation/widgets/media/enums/image_source.dart

/// The source of the image.
enum ImageSource {
  /// Image from the network.
  network,

  /// Image from local assets.
  asset,

  /// Image from file system.
  file,

  /// Image from memory.
  memory,

  /// Image from a provider (custom).
  provider,
}
