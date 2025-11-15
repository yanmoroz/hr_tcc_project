import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../entities/cancel_application_result.dart';
import '../repositories/application_repository.dart';

class CancelApplicationUsecase {
  final ApplicationRepository _repository;

  CancelApplicationUsecase(this._repository);

  Future<Result<CancelApplicationResult>> call(String id) async {
    return await _repository.cancelApplication(id);
  }
}
