// lib/domain/usecases/auth/register_usecase.dart

import 'package:equatable/equatable.dart';

import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../exceptions/auth_exceptions.dart';

/// Parameters for [RegisterUseCase].
class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String displayName;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

/// Use case for user registration.
///
/// This use case handles new user registration with email and password.
/// It validates the input before delegating to the repository.
class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase({
    required AuthRepository repository,
  }) : _repository = repository;

  /// Executes the registration use case.
  ///
  /// [params] contains the email, password, and display name for registration.
  /// Returns a [User] if registration is successful.
  /// Throws [AuthException] if validation fails or registration fails.
  Future<User> call(RegisterParams params) async {
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

    // Business rule: password must contain at least one number
    if (!params.password.contains(RegExp(r'[0-9]'))) {
      throw const AuthException('Password must contain at least one number.');
    }

    // Business rule: password must contain at least one uppercase letter
    if (!params.password.contains(RegExp(r'[A-Z]'))) {
      throw const AuthException('Password must contain at least one uppercase letter.');
    }

    // Business rule: password must contain at least one lowercase letter
    if (!params.password.contains(RegExp(r'[a-z]'))) {
      throw const AuthException('Password must contain at least one lowercase letter.');
    }

    // Business rule: password must contain at least one special character
    if (!params.password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      throw const AuthException('Password must contain at least one special character.');
    }

    // Business rule: display name must not be empty
    if (params.displayName.trim().isEmpty) {
      throw const AuthException('Display name cannot be empty.');
    }

    // Business rule: display name must be at least 2 characters
    if (params.displayName.trim().length < 2) {
      throw const AuthException('Display name must be at least 2 characters.');
    }

    // Business rule: display name must not exceed 50 characters
    if (params.displayName.trim().length > 50) {
      throw const AuthException('Display name must not exceed 50 characters.');
    }

    // Sanitize inputs
    final sanitizedEmail = params.email.trim().toLowerCase();
    final sanitizedPassword = params.password.trim();
    final sanitizedName = params.displayName.trim();

    // Delegate to repository
    return _repository.registerWithEmail(
      email: sanitizedEmail,
      password: sanitizedPassword,
      displayName: sanitizedName,
    );
  }
}
