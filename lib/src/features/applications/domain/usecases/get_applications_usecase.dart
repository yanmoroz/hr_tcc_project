import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../../../../core/value_objects/status_group_type.dart';
import '../entities/application_info.dart';
import '../entities/application_statistics.dart';
import '../repositories/application_repository.dart';

class GetApplicationsUsecase {
  final ApplicationRepository _repository;

  GetApplicationsUsecase(this._repository);

  Future<Result<(List<ApplicationInfo>, int, List<ApplicationStatistics>)>>
  call({
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
