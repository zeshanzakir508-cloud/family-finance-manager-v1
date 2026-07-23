/// Constants for the Family feature
class FamilyConstants {
  /// Maximum family name length
  static const int maxFamilyNameLength = 50;
  
  /// Minimum family name length
  static const int minFamilyNameLength = 2;
  
  /// Maximum members per family
  static const int maxMembersPerFamily = 50;
  
  /// Invitation code length
  static const int inviteCodeLength = 6;
  
  /// Invitation expiry duration (7 days)
  static const Duration inviteExpiryDuration = Duration(days: 7);
  
  /// Default family name
  static const String defaultFamilyName = 'My Family';
  
  /// Default currency
  static const String defaultCurrency = 'USD';
  
  /// Default timezone
  static const String defaultTimezone = 'UTC';
  
  /// Default country
  static const String defaultCountry = 'US';
  
  /// Default language
  static const String defaultLanguage = 'en';
  
  /// Default budget period
  static const String defaultBudgetPeriod = 'monthly';
  
  /// SharedPreferences keys
  static const String keyCurrentFamilyId = 'current_family_id';
  static const String keyLastFamilyId = 'last_family_id';
  static const String keyFamilyList = 'family_list';
  
  /// Firebase collection names
  static const String collectionFamilies = 'families';
  static const String collectionMembers = 'members';
  static const String collectionInvitations = 'familyInvitations';
  static const String collectionActivities = 'familyActivities';
  
  /// Minimum members required for ownership transfer
  static const int minMembersForTransfer = 2;
  
  /// Maximum pending invites per family
  static const int maxPendingInvites = 20;
  
  /// Family name validation regex (alphanumeric, spaces, hyphens, apostrophes)
  static const String familyNameRegex = r'^[a-zA-Z0-9\s\-&\'"]{2,50}$';
  
  /// Invitation code regex (alphanumeric uppercase)
  static const String inviteCodeRegex = r'^[A-Z0-9]{6}$';
  
  /// Default member avatar colors
  static const List<String> avatarColors = [
    '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', 
    '#FF9F43', '#A29BFE', '#FD79A8', '#00CEC9',
    '#FDCB6E', '#6C5CE7', '#00B894', '#E17055'
  ];
  
  /// Cache durations
  static const Duration cacheDuration = Duration(minutes: 5);
  static const Duration cacheDurationShort = Duration(minutes: 1);
  static const Duration cacheDurationLong = Duration(hours: 1);
  
  /// Debounce delays
  static const Duration debounceDelay = Duration(milliseconds: 300);
  static const Duration debounceDelayLong = Duration(milliseconds: 500);
  
  /// Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);
  
  /// Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  /// Error messages
  static const String errorFamilyNotFound = 'Family not found';
  static const String errorAlreadyMember = 'You are already a member of this family';
  static const String errorNotMember = 'You are not a member of this family';
  static const String errorFamilyFull = 'Family is full';
  static const String errorInvalidInvite = 'Invalid invitation code';
  static const String errorInviteExpired = 'Invitation has expired';
  static const String errorInviteAlreadyUsed = 'Invitation already used';
  static const String errorCannotRemoveOwner = 'Cannot remove the family owner';
  static const String errorCannotTransferToSelf = 'Cannot transfer ownership to yourself';
  static const String errorLastOwner = 'Family must have at least one owner';
  static const String errorFamilyNameExists = 'Family name already exists';
}
