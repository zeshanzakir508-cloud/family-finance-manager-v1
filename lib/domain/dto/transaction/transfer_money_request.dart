/// Request object for transferring money between accounts.
class TransferMoneyRequest {
  final String fromAccountId;
  final String toAccountId;
  final double amount;
  final String categoryId;
  final String description;

  const TransferMoneyRequest({
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    required this.categoryId,
    required this.description,
  });
}
