import '../../../repositories/family_repository.dart';
import '../../dto/family/reject_invitation_request.dart';
import '../../usecases/base_usecase.dart';

/// Rejects a pending family invitation.
class RejectInvitationUseCase
    implements UseCase<void, RejectInvitationRequest> {
  final FamilyRepository _repository;

  const RejectInvitationUseCase({
    required FamilyRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    RejectInvitationRequest params,
  ) async {
    await _repository.rejectInvitation(
      invitationId: params.invitationId,
    );
  }
}
