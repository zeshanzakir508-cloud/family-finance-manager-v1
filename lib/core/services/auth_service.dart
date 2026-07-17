import 'package:firebase_auth/firebase_auth.dart';

/// ============================================================================
/// Family Finance Manager
/// Auth Service
/// ----------------------------------------------------------------------------
/// Centralized wrapper around Firebase Authentication.
///
/// Responsibilities:
/// • User registration
/// • User sign in
/// • User sign out
/// • Password reset
/// • Email verification
/// • Account deletion
/// • User re-authentication
///
/// This service contains all direct Firebase Authentication operations.
/// ============================================================================
class AuthService {
  AuthService({
    required FirebaseAuth firebaseAuth,
  }) : _auth = firebaseAuth;

  final FirebaseAuth _auth;

  /// Stream of authentication state changes.
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Currently authenticated user.
  User? get currentUser => _auth.currentUser;

  /// Returns true if a user is signed in.
  bool get isSignedIn => currentUser != null;

  /// Registers a new user.
  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Signs in using email and password.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Signs out the current user.
  Future<void> signOut() {
    return _auth.signOut();
  }

  /// Sends password reset email.
  Future<void> sendPasswordResetEmail({
    required String email,
  }) {
    return _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  /// Sends email verification.
  Future<void> sendEmailVerification() async {
    await currentUser?.sendEmailVerification();
  }

  /// Reloads the authenticated user.
  Future<void> reloadUser() async {
    await currentUser?.reload();
  }

  /// Deletes the current account.
  Future<void> deleteAccount() async {
    await currentUser?.delete();
  }

  /// Updates user password.
  Future<void> updatePassword({
    required String newPassword,
  }) async {
    await currentUser?.updatePassword(newPassword);
  }

  /// Updates user email.
  Future<void> updateEmail({
    required String newEmail,
  }) async {
    await currentUser?.verifyBeforeUpdateEmail(
      newEmail.trim(),
    );
  }

  /// Re-authenticates the current user.
  Future<void> reauthenticate({
    required String email,
    required String password,
  }) async {
    final user = currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user found.',
      );
    }

    final credential = EmailAuthProvider.credential(
      email: email.trim(),
      password: password,
    );

    await user.reauthenticateWithCredential(
      credential,
    );
  }
}
