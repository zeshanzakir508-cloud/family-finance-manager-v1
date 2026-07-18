// lib/domain/usecases/auth/check_auth_status_usecase.dart

import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../exceptions/auth_exceptions.dart';

/// Use case for checking authentication status.
///
/// This use case checks whether a user is currently authenticated
/// and returns the current user if authenticated.
class CheckAuthStatusUseCase {
  final AuthRepository _repository;

  const CheckAuthStatusUseCase({
    required AuthRepository repository,
  }) : _repository = repository;

  /// Executes the check authentication status use case.
  ///
  /// Returns a [User] if a user is currently authenticated.
  /// Throws [AuthException] if no user is authenticated.
  Future<User> call() async {
    // Business rule: check if user is signed in
    final isSignedIn = await _repository.isSignedIn();

    if (!isSignedIn) {
      throw const AuthException('User is not authenticated.');
    }

    // Business rule: get current user
    // This could also be combined with the check above,
    // but keeping it separate allows for better error handling
    return _repository.getCurrentUser();
  }
}
