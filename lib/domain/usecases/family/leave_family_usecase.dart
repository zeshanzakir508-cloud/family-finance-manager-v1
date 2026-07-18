import '../../../repositories/family_repository.dart';
import '../../dto/family/leave_family_request.dart';
import '../../usecases/base_usecase.dart';

class LeaveFamilyUseCase
    implements UseCase<void, LeaveFamilyRequest> {
  final FamilyRepository _repository;

  const LeaveFamilyUseCase({
    required FamilyRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call(
    LeaveFamilyRequest params,
  ) async {
    await _repository.removeMember(
      familyId: params.familyId,
      userId: params.userId,
    );
  }
}
