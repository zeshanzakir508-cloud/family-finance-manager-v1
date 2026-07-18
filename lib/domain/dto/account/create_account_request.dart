import '../../../models/account_model.dart';

class CreateAccountRequest {
  final AccountModel account;

  const CreateAccountRequest({
    required this.account,
  });
}
