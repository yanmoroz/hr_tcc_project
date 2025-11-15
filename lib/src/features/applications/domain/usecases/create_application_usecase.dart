import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../entities/create_application_result.dart';
import '../repositories/application_repository.dart';

class CreateApplicationUsecase {
  final ApplicationRepository _repository;

  CreateApplicationUsecase(this._repository);

  Future<Result<CreateApplicationResult>> call(
    Map<String, dynamic> request,
  ) async {
    return await _repository.createApplication(request);
  }
}
