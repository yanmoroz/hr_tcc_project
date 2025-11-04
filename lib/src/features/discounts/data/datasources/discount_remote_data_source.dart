import 'package:hr_tcc_project/src/core/network/api_call_executor.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/network/api_constants.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import '../models/discount_detail_model.dart';
import '../models/discount_list_response.dart';
import '../models/stats_response.dart';

abstract class DiscountRemoteDataSource {
  Future<Result<DiscountListResponse>> getDiscounts({required int category, required int source, required int page});

  Future<Result<DiscountDetailModel>> getDiscountDetail(int id);

  Future<Result<StatsResponse>> getDiscountStats(int id);
}

class DiscountRemoteDataSourceImpl implements DiscountRemoteDataSource {
  final ApiClient _apiClient;

  DiscountRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<DiscountListResponse>> getDiscounts({
    required int category,
    required int source,
    required int page,
  }) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        final queryParameters = <String, dynamic>{'page': page, 'category': category, 'source': source};

        return _apiClient.get(ApiConstants.discountsEndpoint, queryParameters: queryParameters);
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return DiscountListResponse.fromJson(data);
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
  Future<Result<StatsResponse>> getDiscountStats(int id) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        return _apiClient.get(ApiConstants.discountStatsEndpoint(id));
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return StatsResponse.fromJson(data);
      },
    );
  }
}
