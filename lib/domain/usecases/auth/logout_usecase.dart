// lib/domain/usecases/auth/logout_usecase.dart

import '../../repositories/auth_repository.dart';
import '../../exceptions/auth_exceptions.dart';

/// Use case for user logout.
///
/// This use case handles user logout, clearing the current session
/// and signing out from the authentication provider.
class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase({
    required AuthRepository repository,
  }) : _repository = repository;

  /// Executes the logout use case.
  ///
  /// Signs out the current user and clears the session.
  /// Throws [AuthException] if logout fails.
  Future<void> call() async {
    // Business rule: logout is always allowed
    // No validation needed - this is a simple operation

    // Delegate to repository
    await _repository.signOut();
  }
}
