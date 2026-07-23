/// Constants for the onboarding feature
class OnboardingConstants {
  /// Number of onboarding pages
  static const int pageCount = 7;

  /// SharedPreferences keys
  static const String keyOnboardingProgress = 'onboarding_progress';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyOnboardingSkipped = 'onboarding_skipped';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyOnboardingVersion = 'onboarding_version';

  /// Animation durations
  static const Duration animationDurationShort = Duration(milliseconds: 300);
  static const Duration animationDurationMedium = Duration(milliseconds: 500);
  static const Duration animationDurationLong = Duration(milliseconds: 800);
  static const Duration animationDurationPageTransition = Duration(milliseconds: 400);
  static const Duration animationDurationConfetti = Duration(seconds: 3);

  /// Default values
  static const int defaultCurrentStep = 0;
  static const double defaultProgress = 0.0;
  static const String defaultVersion = '1.0.0';

  /// Progress indicator dimensions
  static const double progressIndicatorHeight = 4.0;
  static const double progressIndicatorRadius = 2.0;
  static const double pageIndicatorSize = 10.0;
  static const double pageIndicatorSpacing = 8.0;

  /// Button delays
  static const Duration buttonDebounceDelay = Duration(milliseconds: 250);

  /// Animation curves
  static const String animationCurveEaseInOut = 'easeInOut';
  static const String animationCurveEaseOut = 'easeOut';
  static const String animationCurveEaseIn = 'easeIn';
  static const String animationCurveBounce = 'bounce';

  /// Image aspect ratios
  static const double imageAspectRatio = 1.0;
  static const double imageHeightSmall = 120.0;
  static const double imageHeightMedium = 200.0;
  static const double imageHeightLarge = 280.0;

  /// Padding and margins
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  /// Spacing
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  /// Step titles (for accessibility)
  static const List<String> stepTitles = [
    'Welcome',
    'Permissions',
    'Terms & Privacy',
    'Family Setup',
    'Account Setup',
    'Categories',
    'Finish',
  ];

  /// Step subtitles (brief descriptions)
  static const List<String> stepSubtitles = [
    'Get started with your journey',
    'Allow necessary permissions',
    'Accept terms and privacy policy',
    'Set up your family',
    'Create your account',
    'Choose your categories',
    'You\'re all set!',
  ];

  /// Whether each step is required
  static const List<bool> stepRequired = [
    true, // Welcome - Required
    true, // Permissions - Required
    true, // Terms - Required
    false, // Family - Optional
    true, // Account - Required
    false, // Categories - Optional
    true, // Finish - Required
  ];

  /// Maximum number of retries for storage operations
  static const int maxStorageRetries = 3;

  /// Timeout duration for storage operations
  static const Duration storageTimeout = Duration(seconds: 5);

  /// Default family name
  static const String defaultFamilyName = 'My Family';

  /// Default account name
  static const String defaultAccountName = 'Main Account';

  /// Default currency
  static const String defaultCurrency = 'USD';

  /// Skip confirmation required
  static const bool requireSkipConfirmation = true;

  /// Exit confirmation required
  static const bool requireExitConfirmation = true;

  /// Enable confetti on finish
  static const bool enableFinishConfetti = true;

  /// Enable haptic feedback
  static const bool enableHapticFeedback = true;

  /// Enable sound effects
  static const bool enableSoundEffects = false;

  /// Onboarding version (for migration)
  static const String onboardingVersion = '1.0.0';

  /// Minimum time spent on each page (for analytics)
  static const Duration minPageViewDuration = Duration(seconds: 1);

  /// Maximum time allowed for onboarding (for timeout handling)
  static const Duration maxOnboardingDuration = Duration(minutes: 10);
}
