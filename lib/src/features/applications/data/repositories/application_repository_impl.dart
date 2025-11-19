import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../../../../core/dictionaries/data/models/models.dart';
import '../../../../core/entities/system_status.dart';
import '../../../../core/value_objects/application_status.dart';
import '../../../../core/value_objects/status_group_type.dart';
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
  createApplication(Map<String, dynamic> request) async {
    final result = await _remoteDataSource.createApplication(request);
    return result.map(
      (model) => (
        status: model.parsedStatus,
        instance: model.instance,
        id: model.id,
        idApplication: model.idApplication,
      ),
    );
  }

  @override
  Future<
    Result<({ApplicationStatus status, String id, SystemStatus systemStatus})>
  >
  cancelApplication(String id) async {
    final result = await _remoteDataSource.cancelApplication(id);
    return result.map(
      (model) => (
        status: model.parsedStatus,
        id: model.id,
        systemStatus: model.systemStatusModel.toDomain(),
      ),
    );
  }

  @override
  Future<
    Result<({ApplicationStatus status, String id, SystemStatus systemStatus})>
  >
  checkCancelStatus(String id) async {
    final result = await _remoteDataSource.checkCancelStatus(id);
    return result.map(
      (model) => (
        status: model.parsedStatus,
        id: model.id,
        systemStatus: model.systemStatusModel.toDomain(),
      ),
    );
  }

  @override
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
  checkApplicationStatus({
    required String applicationFormCode,
    required String instance,
  }) async {
    final result = await _remoteDataSource.checkApplicationStatus(
      applicationFormCode: applicationFormCode,
      instance: instance,
    );
    return result.map(
      (model) => (
        status: model.parsedStatus,
        instance: model.instance,
        id: model.id,
        idApplication: model.idApplication,
      ),
    );
  }
}
