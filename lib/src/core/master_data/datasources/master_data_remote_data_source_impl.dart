import '../../base_types/result.dart';
import '../../network/api_call_executor.dart';
import '../../network/api_client.dart';
import '../../network/api_constants.dart';
import '../models/core_dictionaries_response_model.dart';
import 'master_data_remote_data_source.dart';

class MasterDataRemoteDataSourceImpl implements MasterDataRemoteDataSource {
  final ApiClient _apiClient;

  MasterDataRemoteDataSourceImpl(this._apiClient);

  Future<Result<CoreDictionariesResponseModel>>
  fetchAllCoreDictionaries() async {
    // Fetch from API
    return await ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.coreDictionariesEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CoreDictionariesResponseModel.fromJson(data);
      },
    );
  }
}
