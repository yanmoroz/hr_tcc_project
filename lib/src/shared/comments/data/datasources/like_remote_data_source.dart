import 'package:hr_tcc_project/src/core/network/api_call_executor.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';
import '../models/like_response.dart';

/// Generic like data source that works with any entity type
/// Requires endpoint factory functions to be provided
abstract class LikeRemoteDataSource {
  Future<Result<LikeResponse>> toggleEntityLike(int entityId);

  Future<Result<LikeResponse>> toggleCommentLike(int entityId, int commentId);
}

/// Implementation with configurable endpoint paths
class LikeRemoteDataSourceImpl implements LikeRemoteDataSource {
  final ApiClient _apiClient;
  final String Function(int entityId) _toggleEntityLikeEndpoint;
  final String Function(int entityId, int commentId) _toggleCommentLikeEndpoint;

  LikeRemoteDataSourceImpl({
    required ApiClient apiClient,
    required String Function(int entityId) toggleEntityLikeEndpoint,
    required String Function(int entityId, int commentId)
    toggleCommentLikeEndpoint,
  }) : _apiClient = apiClient,
       _toggleEntityLikeEndpoint = toggleEntityLikeEndpoint,
       _toggleCommentLikeEndpoint = toggleCommentLikeEndpoint;

  @override
  Future<Result<LikeResponse>> toggleEntityLike(int entityId) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () => _apiClient.post(_toggleEntityLikeEndpoint(entityId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return LikeResponse.fromJson(data);
      },
    );
  }

  @override
  Future<Result<LikeResponse>> toggleCommentLike(
    int entityId,
    int commentId,
  ) async {
    return ApiCallExecutor.executeApiCall(
      apiCall: () =>
          _apiClient.post(_toggleCommentLikeEndpoint(entityId, commentId)),
      successParser: (response) {
        final data = response.data as Map<String, dynamic>;
        return LikeResponse.fromJson(data);
      },
    );
  }
}
