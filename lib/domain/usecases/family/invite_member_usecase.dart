import '../../../repositories/family_repository.dart';
import '../../dto/family/invite_member_request.dart';
import '../../usecases/base_usecase.dart';

class InviteMemberUseCase
    implements UseCase<void, InviteMemberRequest> {
  final FamilyRepository _repository;

  const InviteMemberUseCase({
    required FamilyRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    InviteMemberRequest params,
  ) async {
    await _repository.inviteMember(
      familyId: params.familyId,
      email: params.email,
    );
  }
}
