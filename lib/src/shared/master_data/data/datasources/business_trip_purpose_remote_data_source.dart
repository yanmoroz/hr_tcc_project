import '../../../../core/types/result.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_constants.dart';
import '../data.dart';

abstract class BusinessTripPurposeRemoteDataSource {
  Future<Result<List<BusinessTripPurposeModel>>> getBusinessTripPurposes();
}

class BusinessTripPurposeRemoteDataSourceImpl implements BusinessTripPurposeRemoteDataSource {
  final ApiClient _apiClient;

  BusinessTripPurposeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<BusinessTripPurposeModel>>> getBusinessTripPurposes() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.businessTripPurposeEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final businessTripPurposesJson = data['businessTripPurposes'] as List<dynamic>;
        return businessTripPurposesJson
            .map((json) => BusinessTripPurposeModel.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
