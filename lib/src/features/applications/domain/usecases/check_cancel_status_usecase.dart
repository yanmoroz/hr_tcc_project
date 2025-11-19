import '../../../../core/base_types/result.dart';
import '../repositories/application_repository.dart';
import '../results/check_cancel_status_result.dart';

class CheckCancelStatusUsecase {
  final ApplicationRepository _repository;

  CheckCancelStatusUsecase(this._repository);

  Future<Result<CheckCancelStatusResult>> call(String id) async {
    return await _repository.checkCancelStatus(id);
  }
}
