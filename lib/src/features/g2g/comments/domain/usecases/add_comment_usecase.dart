import '../../../../../core/base_types/result.dart';
import '../entities/comment.dart';
import '../repositories/comment_repository.dart';
import '../value_objects/commentable_entity_type.dart';

class AddCommentUsecase {
  final CommentRepository repository;

  AddCommentUsecase(this.repository);

  Future<Result<Comment>> call({
    required int entityId,
    required CommentableEntityType entityType,
    required String content,
    int? parent,
    List<int>? attachments,
  }) {
    return repository.addComment(
      entityId: entityId,
      entityType: entityType,
      content: content,
      parent: parent,
      attachments: attachments,
    );
  }
}
