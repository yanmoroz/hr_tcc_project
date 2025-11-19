import '../../../../core/base_types/result.dart';
import '../../../../core/value_objects/application_status.dart';
import '../repositories/application_repository.dart';

class CheckApplicationStatusUsecase {
  final ApplicationRepository _repository;

  CheckApplicationStatusUsecase(this._repository);

  Future<
    Result<
      ({
        ApplicationStatus status,
        String? instance,
        String? id,
        String? idApplication,
      })
    >
  >
  call({required String applicationFormCode, required String instance}) async {
    return await _repository.checkApplicationStatus(
      applicationFormCode: applicationFormCode,
      instance: instance,
    );
  }
}
