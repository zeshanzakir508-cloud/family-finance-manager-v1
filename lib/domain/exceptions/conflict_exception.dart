import 'domain_exception.dart';

/// Thrown when an operation conflicts with the current state.
///
/// Example:
/// - Duplicate account
/// - Duplicate category
/// - Family already exists
class ConflictException extends DomainException {
  const ConflictException(super.message);
}
