import '../../../models/budget_model.dart';

class CreateBudgetRequest {
  final BudgetModel budget;

  const CreateBudgetRequest({
    required this.budget,
  });
}
