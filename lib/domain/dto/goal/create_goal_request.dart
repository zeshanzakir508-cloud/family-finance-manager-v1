import '../../../models/goal_model.dart';

class CreateGoalRequest {
  final GoalModel goal;

  const CreateGoalRequest({
    required this.goal,
  });
}
