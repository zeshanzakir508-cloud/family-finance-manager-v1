import 'domain_exception.dart';

/// Thrown when a required domain object cannot be found.
class NotFoundException extends DomainException {
  const NotFoundException(super.message);
}
