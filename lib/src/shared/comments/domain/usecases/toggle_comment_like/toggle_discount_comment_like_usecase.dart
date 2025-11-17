import '../../../../../core/base_types/result.dart';
import '../../repositories/comment_repository.dart';
import 'toggle_comment_like.dart';

class ToggleDiscountCommentLikeUsecase implements ToggleCommentLikeUsecase {
  final CommentRepository repository;

  ToggleDiscountCommentLikeUsecase(this.repository);

  @override
  Future<Result<bool>> call({
    required int entityId,
    required int commentId,
  }) async {
    return await repository.toggleDiscountCommentLike(entityId, commentId);
  }
}
