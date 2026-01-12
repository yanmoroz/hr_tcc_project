import '../../../base_types/result.dart';
import '../../../logging/app_logger.dart';
import '../../../network/api_call_executor.dart';
import '../../dadata_constants.dart';
import '../models/dadata_suggestion_model.dart';
import '../network/dadata_client.dart';
import 'dadata_remote_data_source.dart';

/// Implementation of DaDataRemoteDataSource using DaDataClient
class DaDataRemoteDataSourceImpl implements DaDataRemoteDataSource {
  final DaDataClient _client;

  DaDataRemoteDataSourceImpl(this._client);

  @override
  Future<Result<DaDataSuggestionsResponseModel>> getAddressSuggestions(
    String query,
  ) async {
    return _getSuggestions(
      endpoint: DaDataConstants.addressSuggestionsEndpoint,
      query: query,
    );
  }

  @override
  Future<Result<DaDataSuggestionsResponseModel>> getCountrySuggestions(
    String query,
  ) async {
    return _getSuggestions(
      endpoint: DaDataConstants.countrySuggestionsEndpoint,
      query: query,
    );
  }

  @override
  Future<Result<DaDataSuggestionsResponseModel>> getPartySuggestions(
    String query,
  ) async {
    return _getSuggestions(
      endpoint: DaDataConstants.partySuggestionsEndpoint,
      query: query,
    );
  }

  Future<Result<DaDataSuggestionsResponseModel>> _getSuggestions({
    required String endpoint,
    required String query,
  }) async {
    try {
      return await ApiCallExecutor.executeApiCall<
        DaDataSuggestionsResponseModel
      >(
        apiCall: () => _client.post(endpoint, data: {'query': query}),
        successParser: (response) {
          final json = response.data as Map<String, dynamic>;
          return DaDataSuggestionsResponseModel.fromJson(json);
        },
        validStatusCodes: [200],
      );
    } catch (e, stackTrace) {
      AppLogger.e(
        'Error fetching DaData suggestions from $endpoint',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
