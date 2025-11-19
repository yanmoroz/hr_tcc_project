import '../../../../core/base_types/result.dart';
import '../repositories/application_repository.dart';
import '../params/create_application_params.dart';
import '../results/create_application_result.dart';

class CreateApplicationUsecase {
  final ApplicationRepository _repository;

  CreateApplicationUsecase(this._repository);

  Future<Result<CreateApplicationResult>> call(
    CreateApplicationParams params,
  ) async {
    return await _repository.createApplication(params);
  }
}
