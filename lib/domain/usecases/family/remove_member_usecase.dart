import '../../../repositories/family_repository.dart';
import '../../dto/family/remove_member_request.dart';
import '../../usecases/base_usecase.dart';

class RemoveMemberUseCase
    implements UseCase<void, RemoveMemberRequest> {
  final FamilyRepository _repository;

  const RemoveMemberUseCase({
    required FamilyRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    RemoveMemberRequest params,
  ) async {
    await _repository.removeMember(
      familyId: params.familyId,
      userId: params.userId,
    );
  }
}
