import '../../../../../core/base_types/result.dart';
import '../entities/comment.dart';
import '../value_objects/commentable_entity_type.dart';

abstract class CommentRepository {
  Future<Result<Comment>> addComment({
    required int entityId,
    required CommentableEntityType entityType,
    required String content,
    int? parent,
    List<int>? attachments,
  });
  Future<Result<List<int>>> deleteComment({
    required int entityId,
    required CommentableEntityType entityType,
    required int commentId,
  });
  Future<Result<List<Comment>>> getComments({
    required int entityId,
    required CommentableEntityType entityType,
  });
  Future<Result<bool>> toggleCommentLike({
    required int entityId,
    required CommentableEntityType entityType,
    required int commentId,
  });
}
