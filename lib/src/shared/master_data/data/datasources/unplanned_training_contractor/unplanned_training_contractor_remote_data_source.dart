import '../../../../../core/types/result.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../data.dart';

abstract class UnplannedTrainingContractorRemoteDataSource {
  Future<Result<List<UnplannedTrainingContractorModel>>> getUnplannedTrainingContractors();
}

class UnplannedTrainingContractorRemoteDataSourceImpl implements UnplannedTrainingContractorRemoteDataSource {
  final ApiClient _apiClient;

  UnplannedTrainingContractorRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<UnplannedTrainingContractorModel>>> getUnplannedTrainingContractors() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.unplannedTrainingContractorEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final contractorsJson = data['contractors'] as List<dynamic>;
        return contractorsJson
            .map((json) => UnplannedTrainingContractorModel.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
