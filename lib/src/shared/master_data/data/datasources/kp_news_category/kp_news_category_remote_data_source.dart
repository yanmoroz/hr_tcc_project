import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_call_executor.dart';
import '../../../../../core/network/api_constants.dart';
import '../../models/models.dart';

abstract class KpNewsCategoryRemoteDataSource {
  Future<Either<NetworkException, List<KpNewsCategoryModel>>> getKpNewsCategories();
}

class KpNewsCategoryRemoteDataSourceImpl implements KpNewsCategoryRemoteDataSource {
  final ApiClient _apiClient;

  KpNewsCategoryRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Either<NetworkException, List<KpNewsCategoryModel>>> getKpNewsCategories() async {
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
