import '../../../../core/base_types/result.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_constants.dart';
import '../../domain/entities/shared_types/staff_target.dart';
import '../data.dart';

class PollRemoteDataSourceImpl implements PollRemoteDataSource {
  final ApiClient _apiClient;

  PollRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<PollModel>>> getPolls({
    int? status,
    required int page,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        final queryParameters = <String, String>{'page': page.toString()};
        if (status != null) {
          queryParameters['status'] = status.toString();
        }
        return _apiClient.get(
          ApiConstants.pollsEndpoint,
          queryParameters: queryParameters,
        );
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final itemsJson = data['items'] as List<dynamic>;
        return itemsJson
            .map((json) => PollModel.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }

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
      apiCall: () => _apiClient.post(
        ApiConstants.pollVoteEndpoint(pollId),
        data: request.toJson(),
      ),
      successParser: (_) => null,
      validStatusCodes: [200],
    );
  }

  @override
  Future<Result<List<StaffItemModel>>> getStaff({
    required StaffTarget target,
    String? search,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        final queryParameters = <String, String>{'target': target.value};
        if (search != null && search.isNotEmpty) {
          queryParameters['search'] = search;
        }
        return _apiClient.get(
          ApiConstants.staffEndpoint,
          queryParameters: queryParameters,
        );
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final itemsJson = data['items'] as List<dynamic>;
        return itemsJson
            .map(
              (json) => StaffItemModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      },
    );
  }
}
