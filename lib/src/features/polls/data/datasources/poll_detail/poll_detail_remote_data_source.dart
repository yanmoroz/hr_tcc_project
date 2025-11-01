import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class PollDetailRemoteDataSource {
  Future<Either<NetworkException, PollDetailModel>> getPollDetail(int id);
}

class PollDetailRemoteDataSourceImpl implements PollDetailRemoteDataSource {
  final ApiClient _apiClient;

  PollDetailRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, PollDetailModel>> getPollDetail(int id) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get('${ApiConstants.pollsEndpoint}/$id'),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return PollDetailModel.fromJson(data);
      },
    );
  }
}
