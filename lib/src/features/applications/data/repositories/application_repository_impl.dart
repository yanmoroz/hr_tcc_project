import 'package:hr_tcc_project/src/core/types/result.dart';

import '../../../../core/domain/value_objects/status_group_type.dart';
import '../../domain/domain.dart';
import '../datasources/application_remote_data_source.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationRemoteDataSource _remoteDataSource;

  ApplicationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<(List<ApplicationInfo>, int, List<ApplicationStatistics>)>>
  getApplications({
    required int page,
    required int pageSize,
    StatusGroupType? statusGroup,
    String? search,
  }) async {
    final result = await _remoteDataSource.getApplications(
      page: page,
      pageSize: pageSize,
      statusGroup: statusGroup,
      search: search,
    );

    return result.map((responseModel) {
      final applications = responseModel.applicationInfos
          .map((model) => model.toDomain())
          .toList();
      final statistics = responseModel.statistics
          .map((model) => model.toDomain())
          .toList();
      return (applications, responseModel.total, statistics);
    });
  }

  @override
  Future<Result<ApplicationDetail>> getApplicationDetail(String id) async {
    final result = await _remoteDataSource.getApplicationDetail(id);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<CreateApplicationResult>> createApplication(
    Map<String, dynamic> request,
  ) async {
    final result = await _remoteDataSource.createApplication(request);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<CancelApplicationResult>> cancelApplication(String id) async {
    final result = await _remoteDataSource.cancelApplication(id);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<CancelApplicationResult>> checkCancelStatus(String id) async {
    final result = await _remoteDataSource.checkCancelStatus(id);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<CreateApplicationResult>> checkApplicationStatus({
    required String applicationFormCode,
    required String instance,
  }) async {
    final result = await _remoteDataSource.checkApplicationStatus(
      applicationFormCode: applicationFormCode,
      instance: instance,
    );
    return result.map((model) => model.toDomain());
  }
}
