import 'package:firebase_auth/firebase_auth.dart';

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
/// This repository is responsible ONLY for Firebase Authentication.
/// User profile data stored in Firestore belongs to UserRepository.
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

  /// Permanently deletes the currently authenticated account.
  Future<void> deleteAccount();

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail({
    required String email,
  });

  /// Sends an email verification to the current user.
  Future<void> sendEmailVerification();

  /// Reloads the current Firebase user.
  Future<void> reloadUser();

  /// Updates the current user's password.
  Future<void> updatePassword({
    required String newPassword,
  });

  /// Updates the current user's email.
  Future<void> updateEmail({
    required String newEmail,
  });

  /// Re-authenticates the current user.
  Future<void> reauthenticate({
    required String email,
    required String password,
  });
}
