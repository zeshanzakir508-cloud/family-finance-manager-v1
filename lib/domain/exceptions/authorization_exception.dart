import 'domain_exception.dart';

/// Thrown when the current user is not authorized.
class AuthorizationException extends DomainException {
  const AuthorizationException(super.message);
}
