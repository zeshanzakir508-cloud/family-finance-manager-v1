import 'domain_exception.dart';

/// Thrown when a business rule is violated.
class BusinessRuleException extends DomainException {
  const BusinessRuleException(super.message);
}
