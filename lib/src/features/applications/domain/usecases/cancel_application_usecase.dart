import '../../../../core/base_types/result.dart';
import '../../../../core/entities/system_status.dart';
import '../../../../core/value_objects/application_status.dart';
import '../repositories/application_repository.dart';

class CancelApplicationUsecase {
  final ApplicationRepository _repository;

  CancelApplicationUsecase(this._repository);

  Future<
    Result<({ApplicationStatus status, String id, SystemStatus systemStatus})>
  >
  call(String id) async {
    return await _repository.cancelApplication(id);
  }
}
