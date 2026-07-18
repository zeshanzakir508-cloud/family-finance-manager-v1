// lib/domain/usecases/auth/delete_account_usecase.dart

import 'package:equatable/equatable.dart';

import '../../repositories/auth_repository.dart';
import '../../exceptions/auth_exceptions.dart';

/// Parameters for [DeleteAccountUseCase].
class DeleteAccountParams extends Equatable {
  final String password;

  const DeleteAccountParams({
    required this.password,
  });

  @override
  List<Object?> get props => [password];
}

/// Use case for deleting a user account.
///
/// This use case handles permanent deletion of a user account.
/// It requires re-authentication before deletion for security.
class DeleteAccountUseCase {
  final AuthRepository _repository;

  const DeleteAccountUseCase({
    required AuthRepository repository,
  }) : _repository = repository;

  /// Executes the delete account use case.
  ///
  /// [params] contains the password for re-authentication.
  /// Permanently deletes the current user's account.
  /// Throws [AuthException] if validation fails or deletion fails.
  Future<void> call(DeleteAccountParams params) async {
    // Business rule: password must not be empty
    if (params.password.trim().isEmpty) {
      throw const AuthException('Password cannot be empty.');
    }

    // Business rule: password must meet minimum length requirement
    if (params.password.length < 6) {
      throw const AuthException('Password must be at least 6 characters.');
    }

    // Business rule: check if user is signed in
    final isSignedIn = await _repository.isSignedIn();
    if (!isSignedIn) {
      throw const AuthException('No user is signed in.');
    }

    // Business rule: re-authenticate user before deletion
    // This is a security measure to prevent unauthorized account deletion
    try {
      await _repository.reauthenticate(params.password.trim());
    } on AuthException catch (e) {
      // Re-throw re-authentication errors with a user-friendly message
      throw AuthException('Re-authentication failed: ${e.message}');
    }

    // Business rule: after successful re-authentication, delete account
    await _repository.deleteAccount();
  }
}
