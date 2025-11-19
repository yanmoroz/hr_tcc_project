import '../../../../core/base_types/result.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/value_objects/status_group_type.dart';
import '../models/responses/application_detail_model.dart';
import '../models/responses/application_list_response_model.dart';
import '../models/responses/cancel_application_result_model.dart';
import '../models/requests/check_application_request_model.dart';
import '../models/responses/create_application_result_model.dart';
import 'application_remote_data_source.dart';

class ApplicationRemoteDataSourceImpl implements ApplicationRemoteDataSource {
  final ApiClient _apiClient;

  ApplicationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<ApplicationListResponseModel>> getApplications({
    required int page,
    required int pageSize,
    StatusGroupType? statusGroup,
    String? search,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(
        ApiConstants.applicationsEndpoint,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (statusGroup != null) 'statusGroup': statusGroup.value,
          if (search != null) 'search': search,
        },
      ),
      successParser: (response) {
        return ApplicationListResponseModel.fromJson(response.data);
      },
    );
  }

  @override
  Future<Result<ApplicationDetailModel>> getApplicationDetail(String id) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.applicationDetailEndpoint(id)),
      successParser: (response) {
        return ApplicationDetailModel.fromJson(response.data);
      },
    );
  }

  @override
  Future<Result<CreateApplicationResultModel>> createApplication(
    Map<String, dynamic> request,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () =>
          _apiClient.post(ApiConstants.applicationsEndpoint, data: request),
      successParser: (response) {
        return CreateApplicationResultModel.fromJson(response.data);
      },
    );
  }

  @override
  Future<Result<CancelApplicationResultModel>> cancelApplication(
    String id,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () =>
          _apiClient.post(ApiConstants.cancelApplicationEndpoint(id)),
      successParser: (response) {
        return CancelApplicationResultModel.fromJson(response.data);
      },
    );
  }

  @override
  Future<Result<CancelApplicationResultModel>> checkCancelStatus(
    String id,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () =>
          _apiClient.post(ApiConstants.checkCancelStatusEndpoint(id)),
      successParser: (response) {
        return CancelApplicationResultModel.fromJson(response.data);
      },
    );
  }

  @override
  Future<Result<CreateApplicationResultModel>> checkApplicationStatus({
    required String applicationFormCode,
    required String instance,
  }) async {
    final request = CheckApplicationRequestModel(
      applicationFormCode: applicationFormCode,
      instance: instance,
    );

    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(
        ApiConstants.checkApplicationStatusEndpoint,
        data: request.toJson(),
      ),
      successParser: (response) {
        return CreateApplicationResultModel.fromJson(response.data);
      },
    );
  }
}
