import 'package:hr_tcc_project/src/core/network/api_call_executor.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import '../models/add_comment_request.dart';
import '../models/comment_list_response.dart';
import '../models/comment_model.dart';
import '../models/comment_remove_response.dart';

/// Generic comment data source that works with any entity type
/// Requires endpoint factory functions to be provided
abstract class CommentRemoteDataSource {
  Future<Result<CommentListResponse>> getComments(int entityId);

  Future<Result<CommentModel>> addComment(
    int entityId,
    AddCommentRequest request,
  );

  Future<Result<CommentRemoveResponse>> deleteComment(
    int entityId,
    int commentId,
  );
}

/// Implementation with configurable endpoint paths
class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final ApiClient _apiClient;
  final String Function(int entityId) _getCommentsEndpoint;
  final String Function(int entityId) _addCommentEndpoint;
  final String Function(int entityId, int commentId) _deleteCommentEndpoint;

  CommentRemoteDataSourceImpl({
    required ApiClient apiClient,
    required String Function(int entityId) getCommentsEndpoint,
    required String Function(int entityId) addCommentEndpoint,
    required String Function(int entityId, int commentId) deleteCommentEndpoint,
  })  : _apiClient = apiClient,
        _getCommentsEndpoint = getCommentsEndpoint,
        _addCommentEndpoint = addCommentEndpoint,
        _deleteCommentEndpoint = deleteCommentEndpoint;

  @override
  Future<Result<CommentListResponse>> getComments(int entityId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.get(_getCommentsEndpoint(entityId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentListResponse.fromJson(data);
      },
    );
  }

  @override
  Future<Result<CommentModel>> addComment(
    int entityId,
    AddCommentRequest request,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(
        _addCommentEndpoint(entityId),
        data: request.toJson(),
      ),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentModel.fromJson(data);
      },
    );
  }

  @override
  Future<Result<CommentRemoveResponse>> deleteComment(
    int entityId,
    int commentId,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.delete(_deleteCommentEndpoint(entityId, commentId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return CommentRemoveResponse.fromJson(data);
      },
    );
  }
}