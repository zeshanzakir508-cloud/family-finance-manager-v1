// lib/data/repositories/auth_repository_impl.dart

import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/exceptions/auth_exceptions.dart';
import '../datasources/remote/firebase_auth_data_source.dart';
import '../models/user_model.dart';
import '../models/auth_session_model.dart';

/// Implementation of [AuthRepository] that coordinates between domain and data layers.
///
/// This class delegates all data operations to the appropriate data sources
/// and converts between domain entities and data models.
///
/// This class MUST NOT contain any Firebase auth logic, validation, UI code, or Riverpod code.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _remoteDataSource;

  const AuthRepositoryImpl({
    required FirebaseAuthDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  /// Executes a repository operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const AuthDataException('Unexpected repository error.'),
        stackTrace,
      );
    }
  }

  /// Executes a stream repository operation with consistent error handling.
  Stream<T> _executeStream<T>(
    Stream<T> Function() action,
  ) async* {
    try {
      await for (final value in action()) {
        yield value;
      }
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const AuthDataException('Unexpected repository stream error.'),
        stackTrace,
      );
    }
  }

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _execute(() async {
      final model = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return model.toDomain();
    });
  }

  @override
  Future<User> signInWithGoogle() {
    return _execute(() async {
      final model = await _remoteDataSource.signInWithGoogle();
      return model.toDomain();
    });
  }

  @override
  Future<User> signInWithApple() {
    return _execute(() async {
      final model = await _remoteDataSource.signInWithApple();
      return model.toDomain();
    });
  }

  @override
  Future<User> signInWithFacebook() {
    return _execute(() async {
      final model = await _remoteDataSource.signInWithFacebook();
      return model.toDomain();
    });
  }

  @override
  Future<User> signInAnonymously() {
    return _execute(() async {
      final model = await _remoteDataSource.signInAnonymously();
      return model.toDomain();
    });
  }

  @override
  Future<User> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _execute(() async {
      final model = await _remoteDataSource.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      return model.toDomain();
    });
  }

  @override
  Future<void> signOut() {
    return _execute(() async {
      await _remoteDataSource.signOut();
    });
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _execute(() async {
      await _remoteDataSource.sendPasswordResetEmail(email);
    });
  }

  @override
  Future<void> sendEmailVerification() {
    return _execute(() async {
      await _remoteDataSource.sendEmailVerification();
    });
  }

  @override
  Future<void> verifyEmail(String verificationCode) {
    return _execute(() async {
      await _remoteDataSource.verifyEmail(verificationCode);
    });
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _execute(() async {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    });
  }

  @override
  Future<void> updateEmail(String newEmail) {
    return _execute(() async {
      await _remoteDataSource.updateEmail(newEmail);
    });
  }

  @override
  Future<void> updateDisplayName(String displayName) {
    return _execute(() async {
      await _remoteDataSource.updateDisplayName(displayName);
    });
  }

  @override
  Future<void> updatePhotoUrl(String photoUrl) {
    return _execute(() async {
      await _remoteDataSource.updatePhotoUrl(photoUrl);
    });
  }

  @override
  Future<User> getCurrentUser() {
    return _execute(() async {
      final model = await _remoteDataSource.getCurrentUser();
      return model.toDomain();
    });
  }

  @override
  Future<bool> isSignedIn() {
    return _execute(() async {
      return await _remoteDataSource.isSignedIn();
    });
  }

  @override
  Future<String> getIdToken() {
    return _execute(() async {
      return await _remoteDataSource.getIdToken();
    });
  }

  @override
  Future<void> refreshIdToken() {
    return _execute(() async {
      await _remoteDataSource.refreshIdToken();
    });
  }

  @override
  Future<void> deleteAccount() {
    return _execute(() async {
      await _remoteDataSource.deleteAccount();
    });
  }

  @override
  Future<void> reauthenticate(String password) {
    return _execute(() async {
      await _remoteDataSource.reauthenticate(password);
    });
  }

  @override
  Future<AuthSession> getAuthSession() {
    return _execute(() async {
      final model = await _remoteDataSource.getAuthSession();
      return model.toDomain();
    });
  }

  @override
  Future<void> setAuthSession(AuthSession session) {
    return _execute(() async {
      final model = AuthSessionModel.fromDomain(session);
      await _remoteDataSource.setAuthSession(model);
    });
  }

  @override
  Future<void> clearAuthSession() {
    return _execute(() async {
      await _remoteDataSource.clearAuthSession();
    });
  }

  @override
  Future<void> linkWithGoogle() {
    return _execute(() async {
      await _remoteDataSource.linkWithGoogle();
    });
  }

  @override
  Future<void> linkWithApple() {
    return _execute(() async {
      await _remoteDataSource.linkWithApple();
    });
  }

  @override
  Future<void> linkWithFacebook() {
    return _execute(() async {
      await _remoteDataSource.linkWithFacebook();
    });
  }

  @override
  Future<void> unlinkProvider(AuthProvider provider) {
    return _execute(() async {
      await _remoteDataSource.unlinkProvider(provider);
    });
  }

  @override
  Future<List<AuthProvider>> getLinkedProviders() {
    return _execute(() async {
      return await _remoteDataSource.getLinkedProviders();
    });
  }

  @override
  Future<bool> isEmailVerified() {
    return _execute(() async {
      return await _remoteDataSource.isEmailVerified();
    });
  }

  @override
  Future<void> setCustomClaims(Map<String, dynamic> claims) {
    return _execute(() async {
      await _remoteDataSource.setCustomClaims(claims);
    });
  }

  @override
  Stream<User> watchCurrentUser() {
    return _executeStream(
      () => _remoteDataSource.watchCurrentUser().map(
            (model) => model.toDomain(),
          ),
    );
  }

  @override
  Stream<AuthSession> watchAuthSession() {
    return _executeStream(
      () => _remoteDataSource.watchAuthSession().map(
            (model) => model.toDomain(),
          ),
    );
  }

  @override
  Stream<bool> watchAuthState() {
    return _executeStream(
      () => _remoteDataSource.watchAuthState(),
    );
  }

  @override
  Stream<User> watchUserChanges(String userId) {
    return _executeStream(
      () => _remoteDataSource.watchUserChanges(userId).map(
            (model) => model.toDomain(),
          ),
    );
  }
}
