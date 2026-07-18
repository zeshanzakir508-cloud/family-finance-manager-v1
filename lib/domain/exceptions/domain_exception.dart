/// Base exception for all domain-layer errors.
///
/// Domain exceptions represent business rule violations.
///
/// They should not contain any Firebase- or UI-specific logic.
class DomainException implements Exception {
  final String message;

  const DomainException(this.message);

  @override
  String toString() => message;
}
