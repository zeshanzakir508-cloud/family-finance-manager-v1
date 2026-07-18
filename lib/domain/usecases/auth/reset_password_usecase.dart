// lib/domain/usecases/auth/reset_password_usecase.dart

import 'package:equatable/equatable.dart';

import '../../repositories/auth_repository.dart';
import '../../exceptions/auth_exceptions.dart';

/// Parameters for [ResetPasswordUseCase].
class ResetPasswordParams extends Equatable {
  final String email;

  const ResetPasswordParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

/// Use case for password reset.
///
/// This use case handles sending a password reset email to the user.
/// It validates the email before delegating to the repository.
class ResetPasswordUseCase {
  final AuthRepository _repository;

  const ResetPasswordUseCase({
    required AuthRepository repository,
  }) : _repository = repository;

  /// Executes the password reset use case.
  ///
  /// [params] contains the email address for password reset.
  /// Sends a password reset email to the provided address.
  /// Throws [AuthException] if validation fails or the operation fails.
  Future<void> call(ResetPasswordParams params) async {
    // Business rule: email must not be empty
    if (params.email.trim().isEmpty) {
      throw const AuthException('Email address cannot be empty.');
    }

    // Business rule: email must be in valid format
    if (!params.email.contains('@') || !params.email.contains('.')) {
      throw const AuthException('Please enter a valid email address.');
    }

    // Business rule: email must be from a valid domain (example check)
    // This is a basic check - you can add more specific domain validation
    if (params.email.trim().split('@').last.isEmpty) {
      throw const AuthException('Please enter a valid email domain.');
    }

    // Sanitize input
    final sanitizedEmail = params.email.trim().toLowerCase();

    // Delegate to repository
    await _repository.sendPasswordResetEmail(sanitizedEmail);
  }
}
