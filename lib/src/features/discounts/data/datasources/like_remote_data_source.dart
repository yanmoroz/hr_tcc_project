import 'package:hr_tcc_project/src/core/network/api_call_executor.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/network/api_constants.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import '../models/like_response.dart';

abstract class LikeRemoteDataSource {
  Future<Result<LikeResponse>> toggleDiscountLike(int discountId);

  Future<Result<LikeResponse>> toggleCommentLike(
    int discountId,
    int commentId,
  );
}

class LikeRemoteDataSourceImpl implements LikeRemoteDataSource {
  final ApiClient _apiClient;

  LikeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<LikeResponse>> toggleDiscountLike(int discountId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        return _apiClient.post(
          ApiConstants.discountLikeEndpoint(discountId),
        );
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return LikeResponse.fromJson(data);
      },
    );
  }

  @override
  Future<Result<LikeResponse>> toggleCommentLike(
    int discountId,
    int commentId,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        return _apiClient.post(
          ApiConstants.commentLikeEndpoint(discountId, commentId),
        );
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return LikeResponse.fromJson(data);
      },
    );
  }
}
