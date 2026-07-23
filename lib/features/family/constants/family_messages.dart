/// Messages and notifications for the Family feature
class FamilyMessages {
  // ============ Success Messages ============
  static const String familyCreated = 'Family created successfully! 🎉';
  static const String familyJoined = 'You have joined the family! 👋';
  static const String familyLeft = 'You have left the family.';
  static const String familyDeleted = 'Family deleted successfully.';
  static const String familyUpdated = 'Family updated successfully.';
  static const String familySwitched = 'Switched to family successfully.';
  
  static const String memberInvited = 'Member invited successfully! 📧';
  static const String memberRemoved = 'Member removed successfully.';
  static const String memberRoleChanged = 'Member role changed successfully.';
  static const String memberRestored = 'Member restored successfully.';
  static const String memberSuspended = 'Member suspended successfully.';
  static const String ownershipTransferred = 'Ownership transferred successfully.';
  
  static const String inviteSent = 'Invitation sent successfully.';
  static const String inviteAccepted = 'Invitation accepted. Welcome to the family! 🎉';
  static const String inviteRejected = 'Invitation rejected.';
  static const String inviteCancelled = 'Invitation cancelled.';
  
  // ============ Error Messages ============
  static const String errorFamilyCreate = 'Failed to create family. Please try again.';
  static const String errorFamilyJoin = 'Failed to join family. Please check the invitation code.';
  static const String errorFamilyLeave = 'Failed to leave family. Please try again.';
  static const String errorFamilyDelete = 'Failed to delete family. Please try again.';
  static const String errorFamilyUpdate = 'Failed to update family. Please try again.';
  static const String errorFamilySwitch = 'Failed to switch family. Please try again.';
  
  static const String errorInviteMember = 'Failed to invite member. Please try again.';
  static const String errorRemoveMember = 'Failed to remove member. Please try again.';
  static const String errorChangeRole = 'Failed to change role. Please try again.';
  static const String errorTransferOwnership = 'Failed to transfer ownership. Please try again.';
  
  static const String errorInviteInvalid = 'Invalid invitation code.';
  static const String errorInviteExpired = 'Invitation has expired. Please request a new one.';
  static const String errorInviteUsed = 'Invitation has already been used.';
  static const String errorInviteNotFound = 'Invitation not found.';
  
  static const String errorFamilyFull = 'Family is full. Cannot add more members.';
  static const String errorAlreadyMember = 'You are already a member of this family.';
  static const String errorNotMember = 'You are not a member of this family.';
  static const String errorFamilyNotFound = 'Family not found.';
  
  static const String errorCannotRemoveOwner = 'Cannot remove the family owner.';
  static const String errorLastOwner = 'Family must have at least one owner.';
  static const String errorCannotTransferToSelf = 'Cannot transfer ownership to yourself.';
  static const String errorInsufficientMembers = 'Need at least 2 members to transfer ownership.';
  
  static const String errorPermissionDenied = 'You do not have permission to perform this action.';
  static const String errorInvalidInput = 'Invalid input. Please check your entries.';
  static const String errorNetworkConnection = 'Network connection issue. Please check your internet.';
  static const String errorServerError = 'Server error. Please try again later.';
  
  // ============ Validation Messages ============
  static const String validationFamilyNameRequired = 'Family name is required.';
  static const String validationFamilyNameLength = 'Family name must be between 2 and 50 characters.';
  static const String validationFamilyNameInvalid = 'Family name contains invalid characters.';
  static const String validationInviteCodeRequired = 'Invitation code is required.';
  static const String validationInviteCodeLength = 'Invitation code must be 6 characters.';
  static const String validationInviteCodeInvalid = 'Invitation code contains invalid characters.';
  static const String validationMemberNameRequired = 'Member name is required.';
  static const String validationMemberNameLength = 'Member name must be between 2 and 30 characters.';
  
  // ============ Confirmation Messages ============
  static const String confirmLeaveFamily = 'Are you sure you want to leave this family?';
  static const String confirmDeleteFamily = 'Are you sure you want to delete this family? This action cannot be undone.';
  static const String confirmRemoveMember = 'Are you sure you want to remove this member?';
  static const String confirmTransferOwnership = 'Are you sure you want to transfer ownership?';
  static const String confirmSuspendMember = 'Are you sure you want to suspend this member?';
  static const String confirmCancelInvite = 'Are you sure you want to cancel this invitation?';
  
  // ============ Status Messages ============
  static const String statusOwner = 'Owner';
  static const String statusModerator = 'Moderator';
  static const String statusMember = 'Member';
  static const String statusViewer = 'Viewer';
  static const String statusPending = 'Pending';
  static const String statusActive = 'Active';
  static const String statusSuspended = 'Suspended';
  static const String statusBlocked = 'Blocked';
  static const String statusRemoved = 'Removed';
  static const String statusLeft = 'Left';
  
  // ============ Info Messages ============
  static const String infoTransferOwnership = 'Transfer ownership to another member. You will become a moderator.';
  static const String infoLeaveFamily = 'You can leave the family. A new owner must be assigned first.';
  static const String infoDeleteFamily = 'Deleting the family will remove all associated data.';
  static const String infoRoleChange = 'Changing a member\'s role will update their permissions.';
  static const String infoSuspendMember = 'Suspended members cannot access the family until restored.';
}
