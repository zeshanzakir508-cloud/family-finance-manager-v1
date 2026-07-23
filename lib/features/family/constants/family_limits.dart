/// Limits and constraints for the Family feature
class FamilyLimits {
  /// Maximum number of families a user can create
  static const int maxFamiliesPerUser = 5;
  
  /// Maximum members per family
  static const int maxMembers = 50;
  
  /// Maximum pending invitations per family
  static const int maxPendingInvites = 20;
  
  /// Maximum member name length
  static const int maxMemberNameLength = 30;
  
  /// Minimum member name length
  static const int minMemberNameLength = 2;
  
  /// Maximum invitation code attempts
  static const int maxInviteAttempts = 5;
  
  /// Maximum family name length
  static const int maxFamilyNameLength = 50;
  
  /// Minimum family name length
  static const int minFamilyNameLength = 2;
  
  /// Maximum family description length
  static const int maxDescriptionLength = 200;
  
  /// Maximum avatar size in bytes (5MB)
  static const int maxAvatarSizeBytes = 5 * 1024 * 1024;
  
  /// Maximum family activity logs per page
  static const int maxActivityLogsPerPage = 50;
  
  /// Maximum members to display at once in UI
  static const int maxMembersDisplay = 20;
  
  /// Maximum invitation resend attempts
  static const int maxResendAttempts = 3;
  
  /// Maximum time to wait for a member to accept invitation (in days)
  static const int maxInvitePendingDays = 7;
  
  /// Minimum time between sending invitations to the same email (in hours)
  static const int minResendIntervalHours = 24;
  
  /// Maximum family switches per day
  static const int maxFamilySwitchesPerDay = 10;
  
  /// Maximum concurrent members in a family
  static const int maxConcurrentMembers = 50;
  
  /// Maximum number of roles per family
  static const int maxRolesPerFamily = 10;
  
  /// Maximum number of custom permissions per family
  static const int maxCustomPermissionsPerFamily = 20;
  
  /// Maximum number of family administrators
  static const int maxAdminMembers = 5;
}
