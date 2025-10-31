import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class ReferralProgramCandidateRemoteDataSource {
  Future<Either<NetworkException, List<ReferralProgramCandidateModel>>> getReferralProgramCandidates();
}

class ReferralProgramCandidateRemoteDataSourceImpl implements ReferralProgramCandidateRemoteDataSource {
  final ApiClient _apiClient;

  ReferralProgramCandidateRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<ReferralProgramCandidateModel>>> getReferralProgramCandidates() async {
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
