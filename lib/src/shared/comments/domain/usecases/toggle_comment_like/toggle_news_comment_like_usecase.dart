import '../../../../../core/base_types/result.dart';
import '../../repositories/comment_repository.dart';
import 'toggle_comment_like.dart';

class ToggleNewsCommentLikeUsecase implements ToggleCommentLikeUsecase {
  final CommentRepository repository;

  ToggleNewsCommentLikeUsecase(this.repository);

  @override
  Future<Result<bool>> call({
    required int entityId,
    required int commentId,
  }) async {
    return await repository.toggleNewsCommentLike(entityId, commentId);
  }
}
