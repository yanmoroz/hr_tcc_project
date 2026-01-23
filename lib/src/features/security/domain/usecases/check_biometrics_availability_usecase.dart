import '../../../../core/base_types/result.dart';
import '../entities/security_settings.dart';
import '../repositories/security_repository.dart';

class CheckBiometricsAvailabilityUsecase {
  final SecurityRepository _repository;

  CheckBiometricsAvailabilityUsecase(this._repository);

  Future<Result<BiometricsType>> call() {
    return _repository.checkBiometricsAvailability();
  }
}
