import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

/// ============================================================================
/// Family Finance Manager
/// Auth Repository
/// ----------------------------------------------------------------------------
/// Defines the authentication contract for the application.
///
/// Responsibilities:
/// • User registration
/// • User sign in
/// • User sign out
/// • Password reset
/// • Email verification
/// • Authentication state
///
/// NOTE:
/// This is only the contract.
/// Firebase implementation will be provided later.
/// ============================================================================

abstract class AuthRepository {
  /// Stream of Firebase authentication state changes.
  Stream<User?> authStateChanges();

  /// Returns the currently authenticated Firebase user.
  User? get currentFirebaseUser;

  /// Returns true if a user is signed in.
  bool get isSignedIn;

  /// Creates a new account.
  Future<UserCredential> register({
    required String email,
    required String password,
  });

  /// Signs in using email and password.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  Future<void> signOut();

  /// Permanently deletes the current authenticated account.
  Future<void> deleteAccount();

  /// Sends password reset email.
  Future<void> sendPasswordResetEmail({
    required String email,
  });

  /// Sends email verification.
  Future<void> sendEmailVerification();

  /// Reloads the authenticated Firebase user.
  Future<void> reloadUser();

  /// Refreshes and returns the latest user model.
  Future<UserModel?> getCurrentUserModel();

  /// Updates user password.
  Future<void> updatePassword({
    required String newPassword,
  });

  /// Updates user email.
  Future<void> updateEmail({
    required String newEmail,
  });

  /// Re-authenticates the current user.
  Future<void> reauthenticate({
    required String email,
    required String password,
  });
}
