import '../../../../core/base_types/base_repository.dart';
import '../../../../core/base_types/result.dart';
import '../../../../core/dictionaries/data/models/models.dart';
import '../../../../core/value_objects/status_group_type.dart';
import '../../domain/domain.dart';
import '../datasources/application_remote_data_source.dart';
import '../mappers/create_application_params_mapper.dart';

class ApplicationRepositoryImpl
    with BaseRepository
    implements ApplicationRepository {
  final ApplicationRemoteDataSource _remoteDataSource;

  ApplicationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<GetApplicationsResult>> getApplications({
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
      final statistics =
          responseModel.statistics?.map((model) => model.toDomain()).toList() ??
          [];
      return GetApplicationsResult(
        applications: applications,
        total: responseModel.total,
        statistics: statistics,
      );
    });
  }

  @override
  Future<Result<ApplicationDetail>> getApplicationDetail(String id) async {
    final result = await _remoteDataSource.getApplicationDetail(id);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<CreateApplicationResult>> createApplication(
    CreateApplicationParams params,
  ) async {
    final requestModel = params.toRequestModel();
    final result = await _remoteDataSource.createApplication(requestModel);
    return result.map(
      (model) => CreateApplicationResult(
        status: model.parsedStatus,
        instance: model.instance,
        id: model.id,
        idApplication: model.idApplication,
      ),
    );
  }

  @override
  Future<Result<CancelApplicationResult>> cancelApplication(String id) async {
    final result = await _remoteDataSource.cancelApplication(id);
    return result.map(
      (model) => CancelApplicationResult(
        status: model.parsedStatus,
        id: model.id,
        systemStatus: model.systemStatusModel.toDomain(),
      ),
    );
  }

  @override
  Future<Result<CheckCancelStatusResult>> checkCancelStatus(String id) async {
    final result = await _remoteDataSource.checkCancelStatus(id);
    return result.map(
      (model) => CheckCancelStatusResult(
        status: model.parsedStatus,
        id: model.id,
        systemStatus: model.systemStatusModel.toDomain(),
      ),
    );
  }

  @override
  Future<Result<CheckApplicationStatusResult>> checkApplicationStatus({
    required String applicationFormCode,
    required String instance,
  }) async {
    final result = await _remoteDataSource.checkApplicationStatus(
      applicationFormCode: applicationFormCode,
      instance: instance,
    );
    return result.map(
      (model) => CheckApplicationStatusResult(
        status: model.parsedStatus,
        instance: model.instance,
        id: model.id,
        idApplication: model.idApplication,
      ),
    );
  }

  @override
  Future<Result<List<KpAbsenceCategory>>> getKpAbsenceCategories() async {
    final result = await _remoteDataSource.getKpAbsenceCategories();
    return mapResultList(result, (model) => model.toDomain());
  }
}
