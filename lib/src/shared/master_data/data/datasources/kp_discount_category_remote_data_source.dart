import '../../../../core/types/result.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_constants.dart';
import '../data.dart';

abstract class KpDiscountCategoryRemoteDataSource {
  Future<Result<List<KpDiscountCategoryModel>>> getKpDiscountCategories();
}

class KpDiscountCategoryRemoteDataSourceImpl implements KpDiscountCategoryRemoteDataSource {
  final ApiClient _apiClient;

  KpDiscountCategoryRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<KpDiscountCategoryModel>>> getKpDiscountCategories() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.kpDiscountCategoryEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final discountCategoriesJson = data['discountCategories'] as List<dynamic>;
        return discountCategoriesJson
            .map((json) => KpDiscountCategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
