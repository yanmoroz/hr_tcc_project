import '../../../../../core/base_types/result.dart';
import '../entities/comment.dart';
import '../repositories/comment_repository.dart';
import '../value_objects/commentable_entity_type.dart';

class GetCommentsUsecase {
  final CommentRepository repository;

  GetCommentsUsecase(this.repository);

  Future<Result<List<Comment>>> call({
    required int entityId,
    required CommentableEntityType entityType,
  }) {
    return repository.getComments(entityId: entityId, entityType: entityType);
  }
}
