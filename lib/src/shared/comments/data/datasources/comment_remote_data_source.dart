import '../../../../core/base_types/result.dart';
import '../../../../core/network/api_call_executor.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/add_comment_request.dart';
import '../models/comment_list_response.dart';
import '../models/comment_model.dart';
import '../models/comment_remove_response.dart';

/// Generic comment data source that works with any entity type
/// Requires endpoint factory functions to be provided
abstract class CommentRemoteDataSource {
  Future<Result<CommentListResponse>> getNewsComments(int newsId);

  Future<Result<CommentListResponse>> getDiscountComments(int discountId);

  Future<Result<CommentModel>> addNewsComment(
    int newsId,
    AddCommentRequest request,
  );

  Future<Result<CommentModel>> addDiscountComment(
    int discountId,
    AddCommentRequest request,
  );

  Future<Result<CommentRemoveResponse>> deleteNewsComment(
    int newsId,
    int commentId,
  );

  Future<Result<CommentRemoveResponse>> deleteDiscountComment(
    int discountId,
    int commentId,
  );

  Future<Result<bool>> toggleNewsCommentLike(int newsId, int commentId);

  Future<Result<bool>> toggleDiscountCommentLike(int discountId, int commentId);
}

/// Implementation with configurable endpoint paths
class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final ApiClient _apiClient;

  CommentRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Result<CommentListResponse>> getNewsComments(int newsId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(ApiConstants.newsCommentsEndpoint(newsId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentListResponse.fromJson(data);
      },
    );
  }

  @override
  Future<Result<CommentListResponse>> getDiscountComments(
    int discountId,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () =>
          _apiClient.get(ApiConstants.discountCommentsEndpoint(discountId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentListResponse.fromJson(data);
      },
    );
  }

  @override
  Future<Result<CommentModel>> addNewsComment(
    int newsId,
    AddCommentRequest request,
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
    AddCommentRequest request,
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
  Future<Result<CommentRemoveResponse>> deleteNewsComment(
    int newsId,
    int commentId,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.delete(
        ApiConstants.newsCommentEndpoint(newsId, commentId),
      ),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentRemoveResponse.fromJson(data);
      },
    );
  }

  @override
  Future<Result<CommentRemoveResponse>> deleteDiscountComment(
    int discountId,
    int commentId,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.delete(
        ApiConstants.discountCommentEndpoint(discountId, commentId),
      ),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentRemoveResponse.fromJson(data);
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
