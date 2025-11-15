import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../entities/create_application_result.dart';
import '../repositories/application_repository.dart';

class CheckApplicationStatusUsecase {
  final ApplicationRepository _repository;

  CheckApplicationStatusUsecase(this._repository);

  Future<Result<CreateApplicationResult>> call({
    required String applicationFormCode,
    required String instance,
  }) async {
    return await _repository.checkApplicationStatus(
      applicationFormCode: applicationFormCode,
      instance: instance,
    );
  }
}
