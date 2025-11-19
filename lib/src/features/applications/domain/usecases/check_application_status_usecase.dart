import '../../../../core/base_types/result.dart';
import '../repositories/application_repository.dart';
import '../results/check_application_status_result.dart';

class CheckApplicationStatusUsecase {
  final ApplicationRepository _repository;

  CheckApplicationStatusUsecase(this._repository);

  Future<Result<CheckApplicationStatusResult>> call({
    required String applicationFormCode,
    required String instance,
  }) async {
    return await _repository.checkApplicationStatus(
      applicationFormCode: applicationFormCode,
      instance: instance,
    );
  }
}
