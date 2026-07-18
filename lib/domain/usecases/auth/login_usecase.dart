// lib/domain/usecases/auth/login_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../exceptions/auth_exceptions.dart';

/// Parameters for [LoginUseCase].
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Use case for user login.
///
/// This use case handles user authentication with email and password.
/// It validates the input before delegating to the repository.
class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase({
    required AuthRepository repository,
  }) : _repository = repository;

  /// Executes the login use case.
  ///
  /// [params] contains the email and password for login.
  /// Returns a [User] if authentication is successful.
  /// Throws [AuthException] if validation fails or authentication fails.
  Future<User> call(LoginParams params) async {
    // Business rule: email must not be empty
    if (params.email.trim().isEmpty) {
      throw const AuthException('Email address cannot be empty.');
    }

    // Business rule: email must be in valid format
    if (!params.email.contains('@') || !params.email.contains('.')) {
      throw const AuthException('Please enter a valid email address.');
    }

    // Business rule: password must not be empty
    if (params.password.trim().isEmpty) {
      throw const AuthException('Password cannot be empty.');
    }

    // Business rule: password must meet minimum length requirement
    if (params.password.length < 6) {
      throw const AuthException('Password must be at least 6 characters.');
    }

    // Business rule: prevent login attempts with excessive whitespace
    final sanitizedEmail = params.email.trim().toLowerCase();
    final sanitizedPassword = params.password.trim();

    // Delegate to repository
    return _repository.signInWithEmail(
      email: sanitizedEmail,
      password: sanitizedPassword,
    );
  }
}
