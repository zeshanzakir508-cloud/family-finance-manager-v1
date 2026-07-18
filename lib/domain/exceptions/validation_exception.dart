import 'domain_exception.dart';

/// Thrown when business validation fails.
class ValidationException extends DomainException {
  const ValidationException(super.message);
}
