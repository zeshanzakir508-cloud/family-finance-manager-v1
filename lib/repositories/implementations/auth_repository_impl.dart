import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/auth_service.dart';
import '../auth_repository.dart';

/// ============================================================================
/// Family Finance Manager
/// Auth Repository Implementation
/// ----------------------------------------------------------------------------
/// Implements [AuthRepository] using [AuthService].
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
/// This repository only handles Firebase Authentication.
/// Firestore user profile operations belong to UserRepository.
/// ============================================================================
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthService authService,
  }) : _authService = authService;

  final AuthService _authService;

  @override
  Stream<User?> authStateChanges() {
    return _authService.authStateChanges();
  }

  @override
  User? get currentFirebaseUser => _authService.currentUser;

  @override
  bool get isSignedIn => _authService.isSignedIn;

  @override
  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return _authService.register(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _authService.signIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return _authService.signOut();
  }

  @override
  Future<void> deleteAccount() {
    return _authService.deleteAccount();
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) {
    return _authService.sendPasswordResetEmail(
      email: email,
    );
  }

  @override
  Future<void> sendEmailVerification() {
    return _authService.sendEmailVerification();
  }

  @override
  Future<void> reloadUser() {
    return _authService.reloadUser();
  }

  @override
  Future<void> updatePassword({
    required String newPassword,
  }) {
    return _authService.updatePassword(
      newPassword: newPassword,
    );
  }

  @override
  Future<void> updateEmail({
    required String newEmail,
  }) {
    return _authService.updateEmail(
      newEmail: newEmail,
    );
  }

  @override
  Future<void> reauthenticate({
    required String email,
    required String password,
  }) {
    return _authService.reauthenticate(
      email: email,
      password: password,
    );
  }
}
