import 'package:hr_tcc_project/src/core/types/result.dart';
import 'package:hr_tcc_project/src/shared/master_data/domain/domain.dart';

import '../entities/application_info.dart';
import '../entities/application_statistics.dart';
import '../repositories/application_repository.dart';

class GetApplicationsUsecase {
  final ApplicationRepository _repository;

  GetApplicationsUsecase(this._repository);

  Future<Result<(List<ApplicationInfo>, int, List<ApplicationStatistics>)>> call({
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
