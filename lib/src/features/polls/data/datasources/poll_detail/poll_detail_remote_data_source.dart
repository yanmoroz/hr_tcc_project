import '../../../../../core/types/result.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../data.dart';

abstract class PollDetailRemoteDataSource {
  Future<Result<PollDetailModel>> getPollDetail(int id);
  Future<Result<void>> submitPollAnswers({
    required int pollId,
    required PollAnswersRequestModel request,
  });
}

class PollDetailRemoteDataSourceImpl implements PollDetailRemoteDataSource {
  final ApiClient _apiClient;

  PollDetailRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<PollDetailModel>> getPollDetail(int id) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.pollDetailEndpoint(id)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return PollDetailModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<void>> submitPollAnswers({
    required int pollId,
    required PollAnswersRequestModel request,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(ApiConstants.pollVoteEndpoint(pollId), data: request.toJson()),
      successParser: (_) => null,
      validStatusCodes: [200],
    );
  }
}
