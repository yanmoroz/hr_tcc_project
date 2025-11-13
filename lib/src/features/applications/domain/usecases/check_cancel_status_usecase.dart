import 'package:hr_tcc_project/src/core/types/result.dart';

import '../entities/cancel_application_result.dart';
import '../repositories/application_repository.dart';

class CheckCancelStatusUsecase {
  final ApplicationRepository _repository;

  CheckCancelStatusUsecase(this._repository);

  Future<Result<CancelApplicationResult>> call(String id) async {
    return await _repository.checkCancelStatus(id);
  }
}