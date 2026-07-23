/// Asset paths for the onboarding feature
class OnboardingAssets {
  /// Image assets
  static const String imageWelcome = 'assets/images/onboarding/welcome.png';
  static const String imagePermissions = 'assets/images/onboarding/permissions.png';
  static const String imageTerms = 'assets/images/onboarding/terms.png';
  static const String imageFamily = 'assets/images/onboarding/family.png';
  static const String imageAccount = 'assets/images/onboarding/account.png';
  static const String imageCategories = 'assets/images/onboarding/categories.png';
  static const String imageFinish = 'assets/images/onboarding/finish.png';
  static const String imageSuccess = 'assets/images/onboarding/success.png';
  static const String imageEmpty = 'assets/images/onboarding/empty.png';

  /// Animation assets (Lottie)
  static const String animationWelcome = 'assets/animations/onboarding/welcome.json';
  static const String animationPermissions = 'assets/animations/onboarding/permissions.json';
  static const String animationTerms = 'assets/animations/onboarding/terms.json';
  static const String animationFamily = 'assets/animations/onboarding/family.json';
  static const String animationAccount = 'assets/animations/onboarding/account.json';
  static const String animationCategories = 'assets/animations/onboarding/categories.json';
  static const String animationFinish = 'assets/animations/onboarding/finish.json';
  static const String animationLoading = 'assets/animations/onboarding/loading.json';
  static const String animationConfetti = 'assets/animations/onboarding/confetti.json';
  static const String animationSuccessCheck = 'assets/animations/onboarding/success_check.json';

  /// Icon assets
  static const String iconWelcome = 'assets/icons/onboarding/welcome.svg';
  static const String iconPermissions = 'assets/icons/onboarding/permissions.svg';
  static const String iconTerms = 'assets/icons/onboarding/terms.svg';
  static const String iconFamily = 'assets/icons/onboarding/family.svg';
  static const String iconAccount = 'assets/icons/onboarding/account.svg';
  static const String iconCategories = 'assets/icons/onboarding/categories.svg';
  static const String iconFinish = 'assets/icons/onboarding/finish.svg';

  /// Feature icons
  static const String iconFeatureSecurity = 'assets/icons/onboarding/security.svg';
  static const String iconFeaturePrivacy = 'assets/icons/onboarding/privacy.svg';
  static const String iconFeatureSync = 'assets/icons/onboarding/sync.svg';
  static const String iconFeatureBackup = 'assets/icons/onboarding/backup.svg';
  static const String iconFeatureSupport = 'assets/icons/onboarding/support.svg';
  static const String iconFeatureCollaboration = 'assets/icons/onboarding/collaboration.svg';

  /// Permission icons
  static const String iconPermissionCamera = 'assets/icons/onboarding/camera.svg';
  static const String iconPermissionGallery = 'assets/icons/onboarding/gallery.svg';
  static const String iconPermissionNotifications = 'assets/icons/onboarding/notifications.svg';
  static const String iconPermissionLocation = 'assets/icons/onboarding/location.svg';
  static const String iconPermissionContacts = 'assets/icons/onboarding/contacts.svg';
  static const String iconPermissionStorage = 'assets/icons/onboarding/storage.svg';

  /// Category icons
  static const String iconCategoryFood = 'assets/icons/onboarding/food.svg';
  static const String iconCategoryTransport = 'assets/icons/onboarding/transport.svg';
  static const String iconCategoryShopping = 'assets/icons/onboarding/shopping.svg';
  static const String iconCategoryUtilities = 'assets/icons/onboarding/utilities.svg';
  static const String iconCategoryEntertainment = 'assets/icons/onboarding/entertainment.svg';
  static const String iconCategoryHealthcare = 'assets/icons/onboarding/healthcare.svg';

  /// Social media icons
  static const String iconSocialGoogle = 'assets/icons/onboarding/google.svg';
  static const String iconSocialApple = 'assets/icons/onboarding/apple.svg';
  static const String iconSocialFacebook = 'assets/icons/onboarding/facebook.svg';

  /// Decorative assets
  static const String decorativePattern1 = 'assets/images/onboarding/pattern_1.png';
  static const String decorativePattern2 = 'assets/images/onboarding/pattern_2.png';
  static const String decorativeCircle1 = 'assets/images/onboarding/circle_1.png';
  static const String decorativeCircle2 = 'assets/images/onboarding/circle_2.png';

  /// Background gradients (as SVG or image)
  static const String backgroundGradient1 = 'assets/images/onboarding/gradient_1.png';
  static const String backgroundGradient2 = 'assets/images/onboarding/gradient_2.png';

  /// Helper method to get image for step index
  static String getImageForStep(int index) {
    const images = [
      imageWelcome,
      imagePermissions,
      imageTerms,
      imageFamily,
      imageAccount,
      imageCategories,
      imageFinish,
    ];
    return index < images.length ? images[index] : imageEmpty;
  }

  /// Helper method to get animation for step index
  static String getAnimationForStep(int index) {
    const animations = [
      animationWelcome,
      animationPermissions,
      animationTerms,
      animationFamily,
      animationAccount,
      animationCategories,
      animationFinish,
    ];
    return index < animations.length ? animations[index] : animationLoading;
  }

  /// Helper method to get icon for step index
  static String getIconForStep(int index) {
    const icons = [
      iconWelcome,
      iconPermissions,
      iconTerms,
      iconFamily,
      iconAccount,
      iconCategories,
      iconFinish,
    ];
    return index < icons.length ? icons[index] : iconWelcome;
  }

  /// Helper method to get feature icon by name
  static String getFeatureIcon(String name) {
    const featureIcons = {
      'security': iconFeatureSecurity,
      'privacy': iconFeaturePrivacy,
      'sync': iconFeatureSync,
      'backup': iconFeatureBackup,
      'support': iconFeatureSupport,
      'collaboration': iconFeatureCollaboration,
    };
    return featureIcons[name] ?? iconFeatureSupport;
  }

  /// Helper method to get permission icon by type
  static String getPermissionIcon(String type) {
    const permissionIcons = {
      'camera': iconPermissionCamera,
      'gallery': iconPermissionGallery,
      'notifications': iconPermissionNotifications,
      'location': iconPermissionLocation,
      'contacts': iconPermissionContacts,
      'storage': iconPermissionStorage,
    };
    return permissionIcons[type] ?? iconPermissionStorage;
  }

  /// Helper method to get category icon by type
  static String getCategoryIcon(String category) {
    const categoryIcons = {
      'food': iconCategoryFood,
      'transport': iconCategoryTransport,
      'shopping': iconCategoryShopping,
      'utilities': iconCategoryUtilities,
      'entertainment': iconCategoryEntertainment,
      'healthcare': iconCategoryHealthcare,
    };
    return categoryIcons[category] ?? iconCategoryShopping;
  }
}
