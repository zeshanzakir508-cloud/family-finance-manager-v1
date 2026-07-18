// lib/data/datasources/remote/firebase_auth_data_source.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:facebook_auth/facebook_auth.dart';

import '../../../domain/exceptions/auth_exceptions.dart';
import '../../models/user_model.dart';
import '../../models/auth_session_model.dart';

/// Data source for Firebase Authentication operations.
///
/// This class handles all direct communication with Firebase Auth and
/// converts Firebase results to models. It is the only layer that
/// should contain Firebase Auth code.
///
/// This class MUST NOT contain any business logic, validation, UI code, or Riverpod code.
class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn? _googleSignIn;
  final FacebookAuth? _facebookAuth;

  FirebaseAuthDataSource({
    required FirebaseAuth firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _facebookAuth = facebookAuth;

  /// Executes a Firebase operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e, stackTrace) {
      Error.throwWithStackTrace(_handleAuthException(e), stackTrace);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const AuthException('Unexpected authentication error.'),
        stackTrace,
      );
    }
  }

  /// Executes a stream Firebase operation with consistent error handling.
  Stream<T> _executeStream<T>(
    Stream<T> Function() action,
  ) async* {
    try {
      await for (final value in action()) {
        yield value;
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      Error.throwWithStackTrace(_handleAuthException(e), stackTrace);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const AuthException('Unexpected authentication stream error.'),
        stackTrace,
      );
    }
  }

  /// Converts FirebaseAuthException to domain AuthException.
  AuthException _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return const AuthException('Invalid email address.');
      case 'user-disabled':
        return const AuthException('This user account has been disabled.');
      case 'user-not-found':
        return const AuthException('No user found with this email.');
      case 'wrong-password':
        return const AuthException('Incorrect password.');
      case 'email-already-in-use':
        return const AuthException('This email is already registered.');
      case 'weak-password':
        return const AuthException('Password is too weak.');
      case 'requires-recent-login':
        return const AuthException('Please re-authenticate to perform this action.');
      case 'too-many-requests':
        return const AuthException('Too many requests. Please try again later.');
      case 'network-request-failed':
        return const AuthException('Network error. Please check your connection.');
      case 'operation-not-allowed':
        return const AuthException('This sign-in method is not enabled.');
      case 'account-exists-with-different-credential':
        return const AuthException(
          'An account already exists with the same email but different sign-in credentials.',
        );
      case 'invalid-credential':
        return const AuthException('Invalid authentication credentials.');
      case 'credential-already-in-use':
        return const AuthException('This credential is already linked to another account.');
      case 'invalid-verification-code':
        return const AuthException('Invalid verification code.');
      case 'invalid-verification-id':
        return const AuthException('Invalid verification ID.');
      case 'session-expired':
        return const AuthException('Authentication session has expired.');
      default:
        return AuthException('Authentication error: ${e.message ?? 'Unknown error'}');
    }
  }

  /// Converts Firebase User to UserModel.
  UserModel _userToModel(User user) {
    return UserModel(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      isAnonymous: user.isAnonymous,
      creationTime: user.metadata?.creationTime,
      lastSignInTime: user.metadata?.lastSignInTime,
    );
  }

  /// Converts Firebase User to AuthSessionModel.
  Future<AuthSessionModel> _userToSessionModel(User user) async {
    final idToken = await user.getIdToken();
    return AuthSessionModel(
      userId: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      idToken: idToken,
      refreshToken: user.refreshToken ?? '',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      isAnonymous: user.isAnonymous,
      providers: _getLinkedProvidersFromUser(user),
    );
  }

  /// Gets linked providers from a user object.
  List<AuthProvider> _getLinkedProvidersFromUser(User user) {
    return user.providerData
        .map((info) => info.providerId)
        .where((provider) => provider.isNotEmpty)
        .map(_providerIdToEnum)
        .toList();
  }

  /// Maps Firebase provider ID to AuthProvider enum.
  AuthProvider _providerIdToEnum(String providerId) {
    switch (providerId) {
      case 'google.com':
        return AuthProvider.google;
      case 'apple.com':
        return AuthProvider.apple;
      case 'facebook.com':
        return AuthProvider.facebook;
      case 'password':
        return AuthProvider.email;
      default:
        return AuthProvider.email;
    }
  }

  /// Maps AuthProvider enum to Firebase provider ID.
  String _providerEnumToId(AuthProvider provider) {
    switch (provider) {
      case AuthProvider.google:
        return 'google.com';
      case AuthProvider.apple:
        return 'apple.com';
      case AuthProvider.facebook:
        return 'facebook.com';
      case AuthProvider.email:
        return 'password';
    }
  }

  // ==================== Authentication Methods ====================

  /// Signs in with email and password.
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _execute(() async {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userToModel(result.user!);
    });
  }

  /// Signs in with Google.
  Future<UserModel> signInWithGoogle() {
    if (_googleSignIn == null) {
      throw const AuthException('Google Sign-In is not configured.');
    }

    return _execute(() async {
      final googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in was cancelled.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _firebaseAuth.signInWithCredential(credential);
      return _userToModel(result.user!);
    });
  }

  /// Signs in with Apple.
  Future<UserModel> signInWithApple() {
    return _execute(() async {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final authCredential = OAuthProvider('apple.com').credential(
        idToken: credential.idToken,
        accessToken: credential.accessToken,
      );

      final result = await _firebaseAuth.signInWithCredential(authCredential);
      return _userToModel(result.user!);
    });
  }

  /// Signs in with Facebook.
  Future<UserModel> signInWithFacebook() {
    if (_facebookAuth == null) {
      throw const AuthException('Facebook Sign-In is not configured.');
    }

    return _execute(() async {
      final result = await _facebookAuth!.login();
      if (result.status == LoginStatus.failed) {
        throw const AuthException('Facebook sign-in failed.');
      }

      if (result.status == LoginStatus.cancelled) {
        throw const AuthException('Facebook sign-in was cancelled.');
      }

      final accessToken = result.accessToken?.token;
      if (accessToken == null) {
        throw const AuthException('Failed to get Facebook access token.');
      }

      final credential = FacebookAuthProvider.credential(accessToken);
      final authResult = await _firebaseAuth.signInWithCredential(credential);
      return _userToModel(authResult.user!);
    });
  }

  /// Signs in anonymously.
  Future<UserModel> signInAnonymously() {
    return _execute(() async {
      final result = await _firebaseAuth.signInAnonymously();
      return _userToModel(result.user!);
    });
  }

  // ==================== Registration Methods ====================

  /// Registers a new user with email and password.
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _execute(() async {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user!;
      await user.updateDisplayName(displayName);
      await user.reload();

      // Get the refreshed user
      final refreshedUser = _firebaseAuth.currentUser!;
      return _userToModel(refreshedUser);
    });
  }

  // ==================== Sign Out Methods ====================

  /// Signs out the current user.
  Future<void> signOut() {
    return _execute(() async {
      // Sign out from Google if signed in
      if (_googleSignIn != null) {
        await _googleSignIn!.signOut();
      }

      // Sign out from Facebook if signed in
      if (_facebookAuth != null) {
        await _facebookAuth!.logOut();
      }

      // Sign out from Firebase
      await _firebaseAuth.signOut();
    });
  }

  // ==================== Account Management ====================

  /// Deletes the current user's account.
  Future<void> deleteAccount() {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }
      await user.delete();
    });
  }

  /// Re-authenticates the user with password.
  Future<void> reauthenticate(String password) {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }

      if (user.email == null) {
        throw const AuthException('User has no email address.');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
    });
  }

  // ==================== Password Management ====================

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail(String email) {
    return _execute(() async {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    });
  }

  /// Changes the user's password.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }

      if (user.email == null) {
        throw const AuthException('User has no email address.');
      }

      // Re-authenticate first
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Change password
      await user.updatePassword(newPassword);
    });
  }

  // ==================== Email Verification ====================

  /// Sends an email verification link.
  Future<void> sendEmailVerification() {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }
      await user.sendEmailVerification();
    });
  }

  /// Verifies email using Firebase action code.
  Future<void> verifyEmail(String verificationCode) {
    return _execute(() async {
      // Use Firebase's applyActionCode to verify email
      await _firebaseAuth.applyActionCode(verificationCode);
      // Reload user to update emailVerified status
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.reload();
      }
    });
  }

  /// Checks if the current user's email is verified.
  Future<bool> isEmailVerified() {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return false;
      }
      await user.reload();
      return user.emailVerified;
    });
  }

  // ==================== Profile Management ====================

  /// Updates the user's email (requires re-authentication).
  Future<void> updateEmail(String newEmail) {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }
      await user.verifyBeforeUpdatingEmail(newEmail);
    });
  }

  /// Updates the user's display name.
  Future<void> updateDisplayName(String displayName) {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }
      await user.updateDisplayName(displayName);
      await user.reload();
    });
  }

  /// Updates the user's photo URL.
  Future<void> updatePhotoUrl(String photoUrl) {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }
      await user.updatePhotoURL(photoUrl);
      await user.reload();
    });
  }

  // ==================== User Queries ====================

  /// Gets the current user.
  Future<UserModel> getCurrentUser() {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }
      await user.reload();
      return _userToModel(user);
    });
  }

  /// Checks if a user is signed in.
  Future<bool> isSignedIn() {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return false;
      }
      await user.reload();
      return true;
    });
  }

  /// Gets the current ID token.
  Future<String> getIdToken() {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }
      return await user.getIdToken();
    });
  }

  /// Refreshes the ID token.
  Future<void> refreshIdToken() {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }
      await user.getIdToken(true);
    });
  }

  // ==================== Session Management ====================

  /// Gets the current auth session.
  Future<AuthSessionModel> getAuthSession() {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }

      return await _userToSessionModel(user);
    });
  }

  /// Sets the auth session.
  ///
  /// Firebase Auth manages sessions automatically through its persistence layer.
  /// This method is intentionally unsupported because Firebase doesn't support
  /// manual session setting. Sessions are automatically restored from device storage.
  Future<void> setAuthSession(AuthSessionModel _) {
    throw const AuthException(
      'Firebase Auth manages sessions automatically. Manual session setting is not supported.',
    );
  }

  /// Clears the auth session.
  Future<void> clearAuthSession() {
    return _execute(() async {
      await _firebaseAuth.signOut();
    });
  }

  // ==================== Provider Linking ====================

  /// Links the current user with Google.
  Future<void> linkWithGoogle() {
    if (_googleSignIn == null) {
      throw const AuthException('Google Sign-In is not configured.');
    }

    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }

      final googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in was cancelled.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await user.linkWithCredential(credential);
    });
  }

  /// Links the current user with Apple.
  Future<void> linkWithApple() {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final authCredential = OAuthProvider('apple.com').credential(
        idToken: credential.idToken,
        accessToken: credential.accessToken,
      );

      await user.linkWithCredential(authCredential);
    });
  }

  /// Links the current user with Facebook.
  Future<void> linkWithFacebook() {
    if (_facebookAuth == null) {
      throw const AuthException('Facebook Sign-In is not configured.');
    }

    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }

      final result = await _facebookAuth!.login();
      if (result.status == LoginStatus.failed) {
        throw const AuthException('Facebook sign-in failed.');
      }

      if (result.status == LoginStatus.cancelled) {
        throw const AuthException('Facebook sign-in was cancelled.');
      }

      final accessToken = result.accessToken?.token;
      if (accessToken == null) {
        throw const AuthException('Failed to get Facebook access token.');
      }

      final credential = FacebookAuthProvider.credential(accessToken);
      await user.linkWithCredential(credential);
    });
  }

  /// Unlinks a provider from the current user.
  Future<void> unlinkProvider(AuthProvider provider) {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }

      final providerId = _providerEnumToId(provider);
      await user.unlink(providerId);
    });
  }

  /// Gets the list of linked providers.
  Future<List<AuthProvider>> getLinkedProviders() {
    return _execute(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('No user signed in.');
      }
      return _getLinkedProvidersFromUser(user);
    });
  }

  // ==================== Custom Claims ====================

  /// Sets custom claims for the current user.
  ///
  /// Note: This operation requires the Firebase Admin SDK and cannot be performed
  /// from the client. Custom claims should be set via a Cloud Function
  /// or backend service using the Admin SDK.
  Future<void> setCustomClaims(Map<String, dynamic> claims) {
    throw const AuthException(
      'Custom claims can only be set using Firebase Admin SDK. '
      'Use a Cloud Function or backend service instead.',
    );
  }

  // ==================== Streams ====================

  /// Watches the current user.
  Stream<UserModel> watchCurrentUser() {
    return _executeStream(
      () => _firebaseAuth.authStateChanges().map((user) {
        if (user == null) {
          throw const AuthException('No user signed in.');
        }
        return _userToModel(user);
      }),
    );
  }

  /// Watches the auth session.
  Stream<AuthSessionModel> watchAuthSession() {
    return _executeStream(
      () => _firebaseAuth.idTokenChanges().asyncMap((user) async {
        if (user == null) {
          throw const AuthException('No user signed in.');
        }
        return await _userToSessionModel(user);
      }),
    );
  }

  /// Watches the auth state (signed in or not).
  Stream<bool> watchAuthState() {
    return _executeStream(
      () => _firebaseAuth.authStateChanges().map((user) => user != null),
    );
  }

  /// Watches changes for a specific user.
  Stream<UserModel> watchUserChanges(String userId) {
    return _executeStream(
      () => _firebaseAuth.userChanges().map((user) {
        if (user == null || user.uid != userId) {
          throw const AuthException('User not found.');
        }
        return _userToModel(user);
      }),
    );
  }
}
