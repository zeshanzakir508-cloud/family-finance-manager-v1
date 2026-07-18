/// Base contract for authorization policies.
///
/// Policies determine whether an action is allowed.
///
/// Policies should only contain authorization rules.
///
/// Example:
/// - Can edit transaction
/// - Can remove member
/// - Can delete family
abstract interface class Policy<TContext> {
  void authorize(TContext context);
}
