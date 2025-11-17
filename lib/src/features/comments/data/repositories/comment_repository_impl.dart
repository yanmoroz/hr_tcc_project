import '../../../../core/base_types/base_repository.dart';
import '../../../../core/base_types/result.dart';
import '../../domain/domain.dart';
import '../data.dart';

class CommentRepositoryImpl with BaseRepository implements CommentRepository {
  final CommentRemoteDataSource _remoteDataSource;

  CommentRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Comment>>> getComments({
    required int entityId,
    required CommentableEntityType entityType,
  }) async {
    final result = entityType == CommentableEntityType.news
        ? await _remoteDataSource.getNewsComments(entityId)
        : await _remoteDataSource.getDiscountComments(entityId);

    final comments = result.map(
      (response) => response.comments.map((model) => model.toDomain()).toList(),
    );
    return comments;
  }

  @override
  Future<Result<Comment>> addComment({
    required int entityId,
    required CommentableEntityType entityType,
    required String content,
    int? parent,
    List<int>? attachments,
  }) async {
    final request = AddCommentRequest(
      parent: parent,
      content: content,
      attachments: attachments,
    );
    final result = entityType == CommentableEntityType.news
        ? await _remoteDataSource.addNewsComment(entityId, request)
        : await _remoteDataSource.addDiscountComment(entityId, request);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<List<int>>> deleteComment({
    required int entityId,
    required CommentableEntityType entityType,
    required int commentId,
  }) async {
    final result = entityType == CommentableEntityType.news
        ? await _remoteDataSource.deleteNewsComment(entityId, commentId)
        : await _remoteDataSource.deleteDiscountComment(entityId, commentId);
    return result.map((response) => response.removedIds);
  }

  @override
  Future<Result<bool>> toggleCommentLike({
    required int entityId,
    required CommentableEntityType entityType,
    required int commentId,
  }) async {
    final result = entityType == CommentableEntityType.news
        ? await _remoteDataSource.toggleNewsCommentLike(entityId, commentId)
        : await _remoteDataSource.toggleDiscountCommentLike(
            entityId,
            commentId,
          );
    return result;
  }
}
