/// ============================================================================
/// Family Finance Manager
/// App Assets
/// ----------------------------------------------------------------------------
/// Centralized asset paths.
///
/// Always reference assets through this file instead of hardcoding paths.
/// ============================================================================

class AppAssets {
  AppAssets._();

  //--------------------------------------------------------------------------
  // Images
  //--------------------------------------------------------------------------

  static const String images = 'assets/images';

  static const String logo = '$images/logo.png';
  static const String logoTransparent = '$images/logo_transparent.png';

  static const String placeholder = '$images/placeholder.png';
  static const String emptyState = '$images/empty_state.png';
  static const String noInternet = '$images/no_internet.png';

  //--------------------------------------------------------------------------
  // Icons
  //--------------------------------------------------------------------------

  static const String icons = 'assets/icons';

  static const String appIcon = '$icons/app_icon.png';

  //--------------------------------------------------------------------------
  // Animations (Lottie)
  //--------------------------------------------------------------------------

  static const String animations = 'assets/animations';

  static const String loadingAnimation =
      '$animations/loading.json';

  static const String successAnimation =
      '$animations/success.json';

  static const String errorAnimation =
      '$animations/error.json';

  static const String emptyAnimation =
      '$animations/empty.json';

  static const String noInternetAnimation =
      '$animations/no_internet.json';

  //--------------------------------------------------------------------------
  // Sounds
  //--------------------------------------------------------------------------

  static const String sounds = 'assets/sounds';

  static const String notificationSound =
      '$sounds/notification.mp3';

  static const String successSound =
      '$sounds/success.mp3';

  static const String errorSound =
      '$sounds/error.mp3';

  //--------------------------------------------------------------------------
  // Fonts
  //--------------------------------------------------------------------------

  static const String fonts = 'assets/fonts';
}
