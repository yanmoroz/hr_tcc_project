import '../../../../core/base_types/result.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase(this._repository);

  Future<Result<AuthTokens>> call({
    required String username,
    required String password,
  }) {
    return _repository.login(username: username, password: password);
  }
}
