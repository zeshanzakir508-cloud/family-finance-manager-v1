/// ============================================================================
/// Family Finance Manager
/// App Strings
/// ----------------------------------------------------------------------------
/// Contains global application strings.
/// Feature-specific strings should remain inside their respective modules.
/// ============================================================================

class AppStrings {
  AppStrings._();

  //--------------------------------------------------------------------------
  // App
  //--------------------------------------------------------------------------

  static const String appName = 'Family Finance Manager';

  //--------------------------------------------------------------------------
  // Common
  //--------------------------------------------------------------------------

  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String close = 'Close';
  static const String save = 'Save';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String update = 'Update';
  static const String add = 'Add';
  static const String remove = 'Remove';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String clear = 'Clear';
  static const String reset = 'Reset';
  static const String retry = 'Retry';
  static const String done = 'Done';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String continueText = 'Continue';

  //--------------------------------------------------------------------------
  // Loading
  //--------------------------------------------------------------------------

  static const String loading = 'Loading...';
  static const String pleaseWait = 'Please wait...';

  //--------------------------------------------------------------------------
  // Empty States
  //--------------------------------------------------------------------------

  static const String noDataFound = 'No data found.';
  static const String noInternetConnection = 'No internet connection.';
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';

  //--------------------------------------------------------------------------
  // Validation
  //--------------------------------------------------------------------------

  static const String requiredField = 'This field is required.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String invalidPhone = 'Please enter a valid phone number.';
  static const String passwordTooShort =
      'Password must be at least 8 characters.';
  static const String passwordsDoNotMatch =
      'Passwords do not match.';

  //--------------------------------------------------------------------------
  // Confirmation
  //--------------------------------------------------------------------------

  static const String deleteConfirmation =
      'Are you sure you want to delete this item?';

  static const String logoutConfirmation =
      'Are you sure you want to logout?';

  //--------------------------------------------------------------------------
  // Success
  //--------------------------------------------------------------------------

  static const String savedSuccessfully =
      'Saved successfully.';

  static const String updatedSuccessfully =
      'Updated successfully.';

  static const String deletedSuccessfully =
      'Deleted successfully.';
}
