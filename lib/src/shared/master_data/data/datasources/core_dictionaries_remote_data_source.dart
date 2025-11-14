import '../../../../core/types/result.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_constants.dart';
import '../data.dart';

abstract class CoreDictionariesRemoteDataSource {
  Future<Result<CoreDictionariesResponseModel>> getCoreDictionaries();
}

class CoreDictionariesRemoteDataSourceImpl implements CoreDictionariesRemoteDataSource {
  final ApiClient _apiClient;

  CoreDictionariesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<CoreDictionariesResponseModel>> getCoreDictionaries() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.coreDictionariesEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CoreDictionariesResponseModel.fromJson(data);
      },
    );
  }
}
