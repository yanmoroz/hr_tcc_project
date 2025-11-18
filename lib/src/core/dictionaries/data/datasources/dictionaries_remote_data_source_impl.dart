import '../../../base_types/result.dart';
import '../../../network/api_call_executor.dart';
import '../../../network/api_client.dart';
import '../../../network/api_constants.dart';
import '../models/core_dictionaries_response_model.dart';
import 'dictionaries_remote_data_source.dart';

class DictionariesRemoteDataSourceImpl implements DictionariesRemoteDataSource {
  final ApiClient _apiClient;

  DictionariesRemoteDataSourceImpl(this._apiClient);

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
