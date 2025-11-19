import '../../../../core/base_types/result.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/requests/add_comment_request_model.dart';
import '../models/responses/comment_list_response_model.dart';
import '../models/responses/comment_model.dart';
import 'comment_remote_data_source.dart';

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final ApiClient _apiClient;

  CommentRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<CommentListResponseModel>> getNewsComments(int newsId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.newsCommentsEndpoint(newsId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentListResponseModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<CommentListResponseModel>> getDiscountComments(
    int discountId,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () =>
          _apiClient.get(ApiConstants.discountCommentsEndpoint(discountId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentListResponseModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<CommentModel>> addNewsComment(
    int newsId,
    AddCommentRequestModel request,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(
        ApiConstants.newsCommentsEndpoint(newsId),
        data: request.toJson(),
      ),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<CommentModel>> addDiscountComment(
    int discountId,
    AddCommentRequestModel request,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(
        ApiConstants.discountCommentsEndpoint(discountId),
        data: request.toJson(),
      ),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<List<int>>> deleteNewsComment(int newsId, int commentId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.delete(
        ApiConstants.newsCommentEndpoint(newsId, commentId),
      ),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return List<int>.from(data['removedIds'] as List);
      },
    );
  }

  @override
  Future<Result<List<int>>> deleteDiscountComment(
    int discountId,
    int commentId,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.delete(
        ApiConstants.discountCommentEndpoint(discountId, commentId),
      ),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return List<int>.from(data['removedIds'] as List);
      },
    );
  }

  @override
  Future<Result<bool>> toggleNewsCommentLike(int newsId, int commentId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(
        ApiConstants.newsCommentLikeEndpoint(newsId, commentId),
      ),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return data['like'] as bool;
      },
    );
  }

  @override
  Future<Result<bool>> toggleDiscountCommentLike(
    int discountId,
    int commentId,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(
        ApiConstants.commentLikeEndpoint(discountId, commentId),
      ),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return data['like'] as bool;
      },
    );
  }
}
