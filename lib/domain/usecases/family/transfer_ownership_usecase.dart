import '../../../repositories/family_repository.dart';
import '../../dto/family/transfer_ownership_request.dart';
import '../../exceptions/not_found_exception.dart';
import '../../usecases/base_usecase.dart';

/// Transfers ownership of a family to another member.
class TransferOwnershipUseCase
    implements UseCase<void, TransferOwnershipRequest> {
  final FamilyRepository _repository;

  const TransferOwnershipUseCase({
    required FamilyRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    TransferOwnershipRequest params,
  ) async {
    final exists = await _repository.familyExists(
      params.familyId,
    );

    if (!exists) {
      throw const NotFoundException(
        'Family not found.',
      );
    }

    final isMember = await _repository.isMember(
      familyId: params.familyId,
      userId: params.newOwnerUserId,
    );

    if (!isMember) {
      throw const NotFoundException(
        'New owner is not a family member.',
      );
    }

    await _repository.transferOwnership(
      familyId: params.familyId,
      newOwnerUserId: params.newOwnerUserId,
    );
  }
}
