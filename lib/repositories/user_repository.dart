import '../models/user_model.dart';

/// ============================================================================
/// Family Finance Manager
/// User Repository
/// ----------------------------------------------------------------------------
/// Defines the contract for managing application users.
///
/// Responsibilities:
/// • Create user profile
/// • Read user profile
/// • Update user profile
/// • Soft delete user profile
/// • Restore user profile
/// • Watch profile changes
///
/// NOTE:
/// This file only defines the repository contract.
/// Firebase implementation will be provided later.
/// ============================================================================

abstract class UserRepository {
  /// Creates a new user profile.
  Future<void> createUser(UserModel user);

  /// Returns a user profile by user ID.
  Future<UserModel?> getUser(String userId);

  /// Watches a user profile for real-time updates.
  Stream<UserModel?> watchUser(String userId);

  /// Updates an existing user profile.
  Future<void> updateUser(UserModel user);

  /// Soft deletes a user profile.
  Future<void> deleteUser(String userId);

  /// Restores a previously deleted user profile.
  Future<void> restoreUser(String userId);

  /// Checks whether a user profile exists.
  Future<bool> userExists(String userId);

  /// Updates the user's display name.
  Future<void> updateDisplayName({
    required String userId,
    required String displayName,
  });

  /// Updates the user's profile photo URL.
  Future<void> updatePhotoUrl({
    required String userId,
    required String photoUrl,
  });

  /// Updates the user's preferred language.
  Future<void> updateLanguage({
    required String userId,
    required String languageCode,
  });

  /// Marks the user's email as verified.
  Future<void> setEmailVerified({
    required String userId,
    required bool verified,
  });

  /// Returns the latest version of the authenticated user's profile.
  Future<UserModel?> getCurrentUser();
}
