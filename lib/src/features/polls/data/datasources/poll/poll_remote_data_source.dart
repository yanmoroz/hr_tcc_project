import '../../../../../core/types/result.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class PollRemoteDataSource {
  Future<Result<List<PollModel>>> getPolls({int? status, required int page});
}

class PollRemoteDataSourceImpl implements PollRemoteDataSource {
  final ApiClient _apiClient;

  PollRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<PollModel>>> getPolls({int? status, required int page}) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        final queryParameters = <String, String>{'page': page.toString()};
        if (status != null) {
          queryParameters['status'] = status.toString();
        }
        return _apiClient.get(ApiConstants.pollsEndpoint, queryParameters: queryParameters);
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final itemsJson = data['items'] as List<dynamic>;
        return itemsJson.map((json) => PollModel.fromJson(json as Map<String, dynamic>)).toList();
      },
    );
  }
}
