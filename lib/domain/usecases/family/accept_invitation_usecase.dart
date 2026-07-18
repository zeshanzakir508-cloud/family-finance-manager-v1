import '../../../repositories/family_repository.dart';
import '../../dto/family/accept_invitation_request.dart';
import '../../usecases/base_usecase.dart';

/// Accepts a pending family invitation.
class AcceptInvitationUseCase
    implements UseCase<void, AcceptInvitationRequest> {
  final FamilyRepository _repository;

  const AcceptInvitationUseCase({
    required FamilyRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    AcceptInvitationRequest params,
  ) async {
    await _repository.acceptInvitation(
      invitationId: params.invitationId,
    );
  }
}
