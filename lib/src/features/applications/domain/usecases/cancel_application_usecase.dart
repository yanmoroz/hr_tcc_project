import '../../../../core/base_types/result.dart';
import '../repositories/application_repository.dart';
import '../results/cancel_application_result.dart';

class CancelApplicationUsecase {
  final ApplicationRepository _repository;

  CancelApplicationUsecase(this._repository);

  Future<Result<CancelApplicationResult>> call(String id) async {
    return await _repository.cancelApplication(id);
  }
}
