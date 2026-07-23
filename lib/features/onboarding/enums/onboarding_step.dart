/// Enum representing each step in the onboarding flow
enum OnboardingStep {
  welcome,
  permissions,
  terms,
  family,
  accounts,
  categories,
  finish,
}

/// Extension methods for OnboardingStep
extension OnboardingStepExtension on OnboardingStep {
  /// Get the display name for the step
  String get displayName {
    switch (this) {
      case OnboardingStep.welcome:
        return 'Welcome';
      case OnboardingStep.permissions:
        return 'Permissions';
      case OnboardingStep.terms:
        return 'Terms & Privacy';
      case OnboardingStep.family:
        return 'Family Setup';
      case OnboardingStep.accounts:
        return 'Account Setup';
      case OnboardingStep.categories:
        return 'Categories';
      case OnboardingStep.finish:
        return 'Finish';
    }
  }

  /// Get the short display name for the step (for indicators)
  String get shortDisplayName {
    switch (this) {
      case OnboardingStep.welcome:
        return 'Welcome';
      case OnboardingStep.permissions:
        return 'Permissions';
      case OnboardingStep.terms:
        return 'Terms';
      case OnboardingStep.family:
        return 'Family';
      case OnboardingStep.accounts:
        return 'Account';
      case OnboardingStep.categories:
        return 'Categories';
      case OnboardingStep.finish:
        return 'Done';
    }
  }

  /// Get the index of the step
  int get index {
    return values.indexOf(this);
  }

  /// Get the route name for the step
  String get route {
    return '/onboarding/${name.toLowerCase()}';
  }

  /// Get the icon name for the step
  String get iconName {
    switch (this) {
      case OnboardingStep.welcome:
        return 'welcome';
      case OnboardingStep.permissions:
        return 'permissions';
      case OnboardingStep.terms:
        return 'terms';
      case OnboardingStep.family:
        return 'family';
      case OnboardingStep.accounts:
        return 'account';
      case OnboardingStep.categories:
        return 'categories';
      case OnboardingStep.finish:
        return 'finish';
    }
  }

  /// Check if this step is required
  bool get isRequired {
    switch (this) {
      case OnboardingStep.welcome:
        return true;
      case OnboardingStep.permissions:
        return true;
      case OnboardingStep.terms:
        return true;
      case OnboardingStep.family:
        return false;
      case OnboardingStep.accounts:
        return true;
      case OnboardingStep.categories:
        return false;
      case OnboardingStep.finish:
        return true;
    }
  }

  /// Get the description for the step
  String get description {
    switch (this) {
      case OnboardingStep.welcome:
        return 'Welcome to the app! Let\'s get started.';
      case OnboardingStep.permissions:
        return 'Allow permissions for the best experience.';
      case OnboardingStep.terms:
        return 'Please review and accept our terms.';
      case OnboardingStep.family:
        return 'Set up your family or join one.';
      case OnboardingStep.accounts:
        return 'Create your account to get started.';
      case OnboardingStep.categories:
        return 'Choose categories that matter to you.';
      case OnboardingStep.finish:
        return 'You\'re all set! Start using the app.';
    }
  }

  /// Check if this step requires validation
  bool get requiresValidation {
    switch (this) {
      case OnboardingStep.welcome:
        return false;
      case OnboardingStep.permissions:
        return true;
      case OnboardingStep.terms:
        return true;
      case OnboardingStep.family:
        return false;
      case OnboardingStep.accounts:
        return true;
      case OnboardingStep.categories:
        return false;
      case OnboardingStep.finish:
        return false;
    }
  }

  /// Check if this step can be skipped
  bool get canSkip {
    switch (this) {
      case OnboardingStep.welcome:
        return false;
      case OnboardingStep.permissions:
        return true;
      case OnboardingStep.terms:
        return true;
      case OnboardingStep.family:
        return true;
      case OnboardingStep.accounts:
        return false;
      case OnboardingStep.categories:
        return true;
      case OnboardingStep.finish:
        return false;
    }
  }

  /// Check if this step shows back button
  bool get showBackButton {
    switch (this) {
      case OnboardingStep.welcome:
        return false;
      case OnboardingStep.permissions:
        return true;
      case OnboardingStep.terms:
        return true;
      case OnboardingStep.family:
        return true;
      case OnboardingStep.accounts:
        return true;
      case OnboardingStep.categories:
        return true;
      case OnboardingStep.finish:
        return true;
    }
  }

  /// Get the previous step
  OnboardingStep? get previous {
    final currentIndex = index;
    if (currentIndex == 0) return null;
    return values[currentIndex - 1];
  }

  /// Get the next step
  OnboardingStep? get next {
    final currentIndex = index;
    if (currentIndex == values.length - 1) return null;
    return values[currentIndex + 1];
  }

  /// Check if this is the first step
  bool get isFirst => this == values.first;

  /// Check if this is the last step
  bool get isLast => this == values.last;

  /// Check if this step comes before another step
  bool isBefore(OnboardingStep other) => index < other.index;

  /// Check if this step comes after another step
  bool isAfter(OnboardingStep other) => index > other.index;

  /// Get the step from index
  static OnboardingStep fromIndex(int index) {
    return values[index];
  }

  /// Get the step from string name
  static OnboardingStep fromString(String name) {
    return values.firstWhere(
      (step) => step.name == name,
      orElse: () => OnboardingStep.welcome,
    );
  }

  /// Get all steps as a list
  static List<OnboardingStep> get allSteps => values;

  /// Get only required steps
  static List<OnboardingStep> get requiredSteps =>
      values.where((step) => step.isRequired).toList();

  /// Get only optional steps
  static List<OnboardingStep> get optionalSteps =>
      values.where((step) => !step.isRequired).toList();

  /// Get steps that can be skipped
  static List<OnboardingStep> get skippableSteps =>
      values.where((step) => step.canSkip).toList();
}
