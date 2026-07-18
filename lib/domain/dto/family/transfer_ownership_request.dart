class TransferOwnershipRequest {
  final String familyId;
  final String newOwnerUserId;

  const TransferOwnershipRequest({
    required this.familyId,
    required this.newOwnerUserId,
  });
}
