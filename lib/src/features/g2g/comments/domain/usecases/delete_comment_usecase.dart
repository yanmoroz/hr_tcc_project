import '../../../../../core/base_types/result.dart';
import '../repositories/comment_repository.dart';
import '../value_objects/commentable_entity_type.dart';

class DeleteCommentUsecase {
  final CommentRepository repository;

  DeleteCommentUsecase(this.repository);

  Future<Result<List<int>>> call({
    required int entityId,
    required CommentableEntityType entityType,
    required int commentId,
  }) {
    return repository.deleteComment(
      entityId: entityId,
      entityType: entityType,
      commentId: commentId,
    );
  }
}
