import '../../../../../core/types/result.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class KpNewsCategoryRemoteDataSource {
  Future<Result<List<KpNewsCategoryModel>>> getKpNewsCategories();
}

class KpNewsCategoryRemoteDataSourceImpl implements KpNewsCategoryRemoteDataSource {
  final ApiClient _apiClient;

  KpNewsCategoryRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<KpNewsCategoryModel>>> getKpNewsCategories() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.kpNewsCategoryEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final newsCategoriesJson = data['newsCategories'] as List<dynamic>;
        return newsCategoriesJson.map((json) => KpNewsCategoryModel.fromJson(json as Map<String, dynamic>)).toList();
      },
    );
  }
}
