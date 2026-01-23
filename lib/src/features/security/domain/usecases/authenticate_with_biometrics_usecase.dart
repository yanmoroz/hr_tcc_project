import '../../../../core/base_types/result.dart';
import '../repositories/security_repository.dart';

class AuthenticateWithBiometricsUsecase {
  final SecurityRepository _repository;

  AuthenticateWithBiometricsUsecase(this._repository);

  Future<Result<bool>> call() {
    return _repository.authenticateWithBiometrics();
  }
}
