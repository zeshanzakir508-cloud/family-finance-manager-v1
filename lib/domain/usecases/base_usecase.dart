/// Base contract for all use cases.
///
/// Every use case should implement this interface.
///
/// Example:
/// ```dart
/// class CreateTransactionUseCase
///     implements UseCase<void, CreateTransactionRequest> {
///   @override
///   Future<void> call(CreateTransactionRequest params) async {
///     ...
///   }
/// }
/// ```
abstract interface class UseCase<TResult, TParams> {
  Future<TResult> call(TParams params);
}

/// Base contract for use cases that do not require parameters.
///
/// Example:
/// ```dart
/// class SyncDataUseCase
///     implements NoParamsUseCase<void> {
///   @override
///   Future<void> call() async {
///     ...
///   }
/// }
/// ```
abstract interface class NoParamsUseCase<TResult> {
  Future<TResult> call();
}
