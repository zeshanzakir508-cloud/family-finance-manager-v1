import '../../../repositories/family_repository.dart';
import '../../dto/family/cancel_invitation_request.dart';
import '../../usecases/base_usecase.dart';

/// Cancels a pending family invitation.
class CancelInvitationUseCase
    implements UseCase<void, CancelInvitationRequest> {
  final FamilyRepository _repository;

  const CancelInvitationUseCase({
    required FamilyRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    CancelInvitationRequest params,
  ) async {
    await _repository.cancelInvitation(
      invitationId: params.invitationId,
    );
  }
}
