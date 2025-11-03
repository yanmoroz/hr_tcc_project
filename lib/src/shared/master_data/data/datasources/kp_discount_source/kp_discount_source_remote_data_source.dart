import '../../../../../core/types/result.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../data.dart';

abstract class KpDiscountSourceRemoteDataSource {
  Future<Result<List<KpDiscountSourceModel>>> getKpDiscountSources();
}

class KpDiscountSourceRemoteDataSourceImpl implements KpDiscountSourceRemoteDataSource {
  final ApiClient _apiClient;

  KpDiscountSourceRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<KpDiscountSourceModel>>> getKpDiscountSources() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.kpDiscountSourceEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final discountSourcesJson = data['discountSources'] as List<dynamic>;
        return discountSourcesJson.map((json) => KpDiscountSourceModel.fromJson(json as Map<String, dynamic>)).toList();
      },
    );
  }
}
