import '../../../../core/base_types/result.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/discount_detail_model.dart';
import '../models/discount_list_response_model.dart';
import '../models/kp_discount_category_model.dart';
import '../models/kp_discount_source_model.dart';
import '../models/stats_response_model.dart';
import 'discount_remote_data_source.dart';

class DiscountRemoteDataSourceImpl implements DiscountRemoteDataSource {
  final ApiClient _apiClient;

  DiscountRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<DiscountListResponseModel>> getDiscounts({
    required int category,
    required int source,
    required int page,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        final queryParameters = <String, dynamic>{
          'page': page,
          'category': category,
          'source': source,
        };

        return _apiClient.get(
          ApiConstants.discountsEndpoint,
          queryParameters: queryParameters,
        );
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return DiscountListResponseModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<DiscountDetailModel>> getDiscountDetail(int id) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        return _apiClient.get(ApiConstants.discountDetailEndpoint(id));
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return DiscountDetailModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<StatsResponseModel>> getDiscountStats(int id) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        return _apiClient.get(ApiConstants.discountStatsEndpoint(id));
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return StatsResponseModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<List<KpDiscountSourceModel>>> getKpDiscountSources() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.kpDiscountSourceEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final discountSourcesJson = data['discountSources'] as List<dynamic>;
        return discountSourcesJson
            .map(
              (json) =>
                  KpDiscountSourceModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      },
    );
  }

  @override
  Future<Result<List<KpDiscountCategoryModel>>>
  getKpDiscountCategories() async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.kpDiscountCategoryEndpoint),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        final discountCategoriesJson =
            data['discountCategories'] as List<dynamic>;
        return discountCategoriesJson
            .map(
              (json) => KpDiscountCategoryModel.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();
      },
    );
  }

  @override
  Future<Result<bool>> toggleDiscountLike(int discountId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () =>
          _apiClient.post(ApiConstants.discountLikeEndpoint(discountId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return data['like'] as bool;
      },
    );
  }
}
