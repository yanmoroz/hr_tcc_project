import '../../../../core/base_types/result.dart';
import '../../../../core/value_objects/status_group_type.dart';
import '../repositories/application_repository.dart';
import '../results/get_applications_result.dart';

class GetApplicationsUsecase {
  final ApplicationRepository _repository;

  GetApplicationsUsecase(this._repository);

  Future<Result<GetApplicationsResult>> call({
    required int page,
    required int pageSize,
    StatusGroupType? statusGroup,
    String? search,
  }) async {
    return await _repository.getApplications(
      page: page,
      pageSize: pageSize,
      statusGroup: statusGroup,
      search: search,
    );
  }
}
