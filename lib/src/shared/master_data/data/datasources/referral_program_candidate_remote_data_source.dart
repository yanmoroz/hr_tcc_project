import '../../../../core/types/result.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_constants.dart';
import '../data.dart';

abstract class ReferralProgramCandidateRemoteDataSource {
  Future<Result<List<ReferralProgramCandidateModel>>> getReferralProgramCandidates();
}

class ReferralProgramCandidateRemoteDataSourceImpl implements ReferralProgramCandidateRemoteDataSource {
  final ApiClient _apiClient;

  ReferralProgramCandidateRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<ReferralProgramCandidateModel>>> getReferralProgramCandidates() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.referralProgramCandidateEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final candidatesJson = data['candidates'] as List<dynamic>;
        return candidatesJson
            .map((json) => ReferralProgramCandidateModel.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
