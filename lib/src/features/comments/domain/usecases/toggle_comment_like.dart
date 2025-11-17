import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../repositories/comment_repository.dart';
import '../value_objects/commentable_entity_type.dart';

class ToggleCommentLikeUsecase {
  final CommentRepository repository;

  ToggleCommentLikeUsecase(this.repository);

  Future<Result<bool>> call({
    required int entityId,
    required CommentableEntityType entityType,
    required int commentId,
  }) {
    return repository.toggleCommentLike(
      entityId: entityId,
      entityType: entityType,
      commentId: commentId,
    );
  }
}
