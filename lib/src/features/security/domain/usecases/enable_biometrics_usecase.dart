import 'package:fpdart/fpdart.dart';

import '../../../../core/base_types/result.dart';
import '../repositories/security_repository.dart';

class EnableBiometricsUsecase {
  final SecurityRepository _repository;

  EnableBiometricsUsecase(this._repository);

  Future<Result<Unit>> call(bool enabled) {
    return _repository.setBiometricsEnabled(enabled);
  }
}
