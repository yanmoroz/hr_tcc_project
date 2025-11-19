import '../../../../core/base_types/result.dart';
import '../../../../core/value_objects/application_status.dart';
import '../repositories/application_repository.dart';
import '../params/create_application_params.dart';

class CreateApplicationUsecase {
  final ApplicationRepository _repository;

  CreateApplicationUsecase(this._repository);

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
  call(CreateApplicationParams params) async {
    return await _repository.createApplication(params);
  }
}
