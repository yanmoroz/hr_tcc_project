import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../entities/application_detail.dart';
import '../repositories/application_repository.dart';

class GetApplicationDetailUsecase {
  final ApplicationRepository _repository;

  GetApplicationDetailUsecase(this._repository);

  Future<Result<ApplicationDetail>> call(String id) async {
    return await _repository.getApplicationDetail(id);
  }
}
