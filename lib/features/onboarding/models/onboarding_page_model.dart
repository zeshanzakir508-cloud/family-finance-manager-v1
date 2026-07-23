import 'package:flutter/material.dart';
import '../enums/onboarding_step.dart';

/// Model representing a single onboarding page
class OnboardingPageModel {
  /// The step this page represents
  final OnboardingStep step;

  /// Title of the page
  final String title;

  /// Subtitle of the page
  final String subtitle;

  /// Image asset path
  final String? image;

  /// Animation asset path (Lottie)
  final String? animation;

  /// Button text for primary action
  final String buttonText;

  /// Icon for the page
  final IconData? icon;

  /// Background color for the page
  final Color? backgroundColor;

  /// Foreground color for the page
  final Color? foregroundColor;

  /// Whether this page can be skipped
  final bool canSkip;

  /// Whether this page shows a back button
  final bool showBackButton;

  /// Whether this page requires validation
  final bool requiresValidation;

  /// Description text (additional details)
  final String? description;

  /// Features to highlight on this page
  final List<FeatureItem>? features;

  /// Permission items for permission page
  final List<PermissionItem>? permissions;

  /// Category items for category selection
  final List<CategoryItem>? categories;

  /// Constructor
  const OnboardingPageModel({
    required this.step,
    required this.title,
    required this.subtitle,
    this.image,
    this.animation,
    required this.buttonText,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.canSkip = false,
    this.showBackButton = true,
    this.requiresValidation = false,
    this.description,
    this.features,
    this.permissions,
    this.categories,
  });

  /// Factory constructor for welcome page
  factory OnboardingPageModel.welcome() {
    return OnboardingPageModel(
      step: OnboardingStep.welcome,
      title: 'Welcome to Family Budget',
      subtitle: 'Manage your family finances together, easily and securely.',
      image: 'assets/images/onboarding/welcome.png',
      animation: 'assets/animations/onboarding/welcome.json',
      buttonText: 'Get Started',
      icon: Icons.waving_hand,
      canSkip: false,
      showBackButton: false,
      requiresValidation: false,
      description: 'Track expenses, set budgets, and achieve your financial goals as a family.',
      features: const [
        FeatureItem(
          icon: Icons.security,
          title: 'Secure',
          description: 'Your data is encrypted and safe',
        ),
        FeatureItem(
          icon: Icons.people,
          title: 'Family Sharing',
          description: 'Share budgets with family members',
        ),
        FeatureItem(
          icon: Icons.trending_up,
          title: 'Smart Insights',
          description: 'Get personalized financial insights',
        ),
      ],
    );
  }

  /// Factory constructor for permissions page
  factory OnboardingPageModel.permissions() {
    return OnboardingPageModel(
      step: OnboardingStep.permissions,
      title: 'Allow Permissions',
      subtitle: 'Enable permissions for the best experience.',
      image: 'assets/images/onboarding/permissions.png',
      animation: 'assets/animations/onboarding/permissions.json',
      buttonText: 'Continue',
      icon: Icons.security,
      canSkip: true,
      showBackButton: true,
      requiresValidation: true,
      description: 'We need these permissions to provide you with the full features of the app.',
      permissions: const [
        PermissionItem(
          type: 'notifications',
          title: 'Notifications',
          description: 'Get alerts for budgets and expenses',
          icon: Icons.notifications_active,
          required: false,
        ),
        PermissionItem(
          type: 'storage',
          title: 'Storage',
          description: 'Save receipts and attachments',
          icon: Icons.folder,
          required: true,
        ),
        PermissionItem(
          type: 'camera',
          title: 'Camera',
          description: 'Scan receipts and documents',
          icon: Icons.camera_alt,
          required: false,
        ),
        PermissionItem(
          type: 'location',
          title: 'Location',
          description: 'Add location to expenses',
          icon: Icons.location_on,
          required: false,
        ),
      ],
    );
  }

  /// Factory constructor for terms page
  factory OnboardingPageModel.terms() {
    return OnboardingPageModel(
      step: OnboardingStep.terms,
      title: 'Terms & Privacy',
      subtitle: 'Please review and accept our terms of service.',
      image: 'assets/images/onboarding/terms.png',
      animation: 'assets/animations/onboarding/terms.json',
      buttonText: 'Accept & Continue',
      icon: Icons.description,
      canSkip: false,
      showBackButton: true,
      requiresValidation: true,
      description: 'By continuing, you agree to our Terms of Service and Privacy Policy.',
    );
  }

  /// Factory constructor for family page
  factory OnboardingPageModel.family() {
    return OnboardingPageModel(
      step: OnboardingStep.family,
      title: 'Set Up Your Family',
      subtitle: 'Create or join a family to start managing finances together.',
      image: 'assets/images/onboarding/family.png',
      animation: 'assets/animations/onboarding/family.json',
      buttonText: 'Continue',
      icon: Icons.family_restroom,
      canSkip: true,
      showBackButton: true,
      requiresValidation: false,
      description: 'Invite family members to collaborate on budgets and track expenses together.',
    );
  }

  /// Factory constructor for accounts page
  factory OnboardingPageModel.accounts() {
    return OnboardingPageModel(
      step: OnboardingStep.accounts,
      title: 'Create Your Account',
      subtitle: 'Set up your main account to start tracking.',
      image: 'assets/images/onboarding/account.png',
      animation: 'assets/animations/onboarding/account.json',
      buttonText: 'Create Account',
      icon: Icons.account_balance_wallet,
      canSkip: false,
      showBackButton: true,
      requiresValidation: true,
      description: 'Your account will be used to track all expenses and income.',
    );
  }

  /// Factory constructor for categories page
  factory OnboardingPageModel.categories() {
    return OnboardingPageModel(
      step: OnboardingStep.categories,
      title: 'Choose Categories',
      subtitle: 'Select categories that matter to your family.',
      image: 'assets/images/onboarding/categories.png',
      animation: 'assets/animations/onboarding/categories.json',
      buttonText: 'Continue',
      icon: Icons.category,
      canSkip: true,
      showBackButton: true,
      requiresValidation: false,
      description: 'Categories help you organize and track your expenses effectively.',
      categories: const [
        CategoryItem(
          id: 'food',
          name: 'Food & Dining',
          icon: Icons.restaurant,
          color: '#FF6B6B',
          selected: true,
        ),
        CategoryItem(
          id: 'transport',
          name: 'Transport',
          icon: Icons.directions_car,
          color: '#4ECDC4',
          selected: true,
        ),
        CategoryItem(
          id: 'shopping',
          name: 'Shopping',
          icon: Icons.shopping_bag,
          color: '#45B7D1',
          selected: true,
        ),
        CategoryItem(
          id: 'utilities',
          name: 'Utilities',
          icon: Icons.electric_bolt,
          color: '#96CEB4',
          selected: true,
        ),
        CategoryItem(
          id: 'entertainment',
          name: 'Entertainment',
          icon: Icons.movie,
          color: '#FF9F43',
          selected: false,
        ),
        CategoryItem(
          id: 'healthcare',
          name: 'Healthcare',
          icon: Icons.health_and_safety,
          color: '#A29BFE',
          selected: false,
        ),
      ],
    );
  }

  /// Factory constructor for finish page
  factory OnboardingPageModel.finish() {
    return OnboardingPageModel(
      step: OnboardingStep.finish,
      title: 'You\'re All Set!',
      subtitle: 'Your family budget is ready to use.',
      image: 'assets/images/onboarding/finish.png',
      animation: 'assets/animations/onboarding/finish.json',
      buttonText: 'Go to Dashboard',
      icon: Icons.celebration,
      canSkip: false,
      showBackButton: true,
      requiresValidation: false,
      description: 'Start tracking your expenses and managing your family budget today!',
    );
  }

  /// Factory constructor to create from step
  factory OnboardingPageModel.fromStep(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.welcome:
        return OnboardingPageModel.welcome();
      case OnboardingStep.permissions:
        return OnboardingPageModel.permissions();
      case OnboardingStep.terms:
        return OnboardingPageModel.terms();
      case OnboardingStep.family:
        return OnboardingPageModel.family();
      case OnboardingStep.accounts:
        return OnboardingPageModel.accounts();
      case OnboardingStep.categories:
        return OnboardingPageModel.categories();
      case OnboardingStep.finish:
        return OnboardingPageModel.finish();
    }
  }

  /// Get all pages in order
  static List<OnboardingPageModel> getAllPages() {
    return OnboardingStep.values
        .map((step) => OnboardingPageModel.fromStep(step))
        .toList();
  }

  /// Create a copy with updated fields
  OnboardingPageModel copyWith({
    OnboardingStep? step,
    String? title,
    String? subtitle,
    String? image,
    String? animation,
    String? buttonText,
    IconData? icon,
    Color? backgroundColor,
    Color? foregroundColor,
    bool? canSkip,
    bool? showBackButton,
    bool? requiresValidation,
    String? description,
    List<FeatureItem>? features,
    List<PermissionItem>? permissions,
    List<CategoryItem>? categories,
  }) {
    return OnboardingPageModel(
      step: step ?? this.step,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      image: image ?? this.image,
      animation: animation ?? this.animation,
      buttonText: buttonText ?? this.buttonText,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      canSkip: canSkip ?? this.canSkip,
      showBackButton: showBackButton ?? this.showBackButton,
      requiresValidation: requiresValidation ?? this.requiresValidation,
      description: description ?? this.description,
      features: features ?? this.features,
      permissions: permissions ?? this.permissions,
      categories: categories ?? this.categories,
    );
  }

  @override
  String toString() {
    return 'OnboardingPageModel(step: $step, title: $title, subtitle: $subtitle)';
  }
}

/// Model representing a feature item
class FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// Model representing a permission item
class PermissionItem {
  final String type;
  final String title;
  final String description;
  final IconData icon;
  final bool required;
  bool granted;

  PermissionItem({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    this.required = false,
    this.granted = false,
  });

  PermissionItem copyWith({
    String? type,
    String? title,
    String? description,
    IconData? icon,
    bool? required,
    bool? granted,
  }) {
    return PermissionItem(
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      required: required ?? this.required,
      granted: granted ?? this.granted,
    );
  }
}

/// Model representing a category item
class CategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final String color;
  bool selected;

  CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.selected = false,
  });

  CategoryItem copyWith({
    String? id,
    String? name,
    IconData? icon,
    String? color,
    bool? selected,
  }) {
    return CategoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      selected: selected ?? this.selected,
    );
  }
}
