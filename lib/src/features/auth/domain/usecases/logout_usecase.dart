import 'package:fpdart/fpdart.dart';

import '../../../../core/base_types/result.dart';
import '../../../security/domain/repositories/security_repository.dart';
import '../repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository _authRepository;
  final SecurityRepository _securityRepository;

  LogoutUsecase(this._authRepository, this._securityRepository);

  Future<Result<Unit>> call() async {
    // Clear security settings first (pincode, biometrics)
    await _securityRepository.clearSecuritySettings();
    // Then clear auth tokens
    return _authRepository.logout();
  }
}
