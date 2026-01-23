import 'package:fpdart/fpdart.dart';

import '../../../../core/base_types/result.dart';
import '../repositories/security_repository.dart';

class ClearSecuritySettingsUsecase {
  final SecurityRepository _repository;

  ClearSecuritySettingsUsecase(this._repository);

  Future<Result<Unit>> call() {
    return _repository.clearSecuritySettings();
  }
}
