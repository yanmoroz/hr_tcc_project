import '../../../../../core/types/result.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../data.dart';

abstract class ViolationSecurityLevelRemoteDataSource {
  Future<Result<List<ViolationSecurityLevelModel>>> getViolationSecurityLevels();
}

class ViolationSecurityLevelRemoteDataSourceImpl implements ViolationSecurityLevelRemoteDataSource {
  final ApiClient _apiClient;

  ViolationSecurityLevelRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<ViolationSecurityLevelModel>>> getViolationSecurityLevels() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.violationSecurityLevelEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final securityLevelsJson = data['securityLevels'] as List<dynamic>;
        return securityLevelsJson
            .map((json) => ViolationSecurityLevelModel.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
