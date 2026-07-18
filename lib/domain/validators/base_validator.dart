/// Base contract for all validators.
///
/// Validators should only validate business rules.
///
/// They must not:
/// - access Firestore
/// - access Firebase
/// - access UI
/// - perform network requests
///
/// Throw a domain exception if validation fails.
abstract interface class Validator<T> {
  void validate(T value);
}
