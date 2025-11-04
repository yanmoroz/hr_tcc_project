import 'package:hr_tcc_project/src/core/network/api_call_executor.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/network/api_constants.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import '../models/add_comment_request.dart';
import '../models/comment_list_response.dart';
import '../models/comment_model.dart';
import '../models/comment_remove_response.dart';

abstract class CommentRemoteDataSource {
  Future<Result<CommentListResponse>> getComments(int discountId);

  Future<Result<CommentModel>> addComment(
    int discountId,
    AddCommentRequest request,
  );

  Future<Result<CommentRemoveResponse>> deleteComment(
    int discountId,
    int commentId,
  );
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final ApiClient _apiClient;

  CommentRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<CommentListResponse>> getComments(int discountId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        return _apiClient.get(
          ApiConstants.discountCommentsEndpoint(discountId),
        );
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentListResponse.fromJson(data);
      },
    );
  }

  @override
  Future<Result<CommentModel>> addComment(
    int discountId,
    AddCommentRequest request,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        return _apiClient.post(
          ApiConstants.discountCommentsEndpoint(discountId),
          data: request.toJson(),
        );
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<CommentRemoveResponse>> deleteComment(
    int discountId,
    int commentId,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () {
        return _apiClient.delete(
          ApiConstants.discountCommentEndpoint(discountId, commentId),
        );
      },
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentRemoveResponse.fromJson(data);
      },
    );
  }
}
