import '../../../../core/base_types/result.dart';
import '../entities/security_settings.dart';
import '../repositories/security_repository.dart';

class GetSecuritySettingsUsecase {
  final SecurityRepository _repository;

  GetSecuritySettingsUsecase(this._repository);

  Future<Result<SecuritySettings>> call() {
    return _repository.getSecuritySettings();
  }
}
