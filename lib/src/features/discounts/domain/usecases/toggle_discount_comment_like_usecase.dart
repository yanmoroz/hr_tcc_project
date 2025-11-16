import 'package:hr_tcc_project/src/core/base_types/result.dart';
import 'package:hr_tcc_project/src/shared/comments/domain/usecases/toggle_comment_like.dart';
import '../repositories/discount_repository.dart';

class ToggleDiscountCommentLikeUsecase implements ToggleCommentLikeUsecase {
  final DiscountRepository repository;

  ToggleDiscountCommentLikeUsecase(this.repository);

  @override
  Future<Result<bool>> call({
    required int entityId,
    required int commentId,
  }) async {
    return await repository.toggleDiscountCommentLike(entityId, commentId);
  }
}
