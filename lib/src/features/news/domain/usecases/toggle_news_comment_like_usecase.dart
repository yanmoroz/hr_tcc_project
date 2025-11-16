import 'package:hr_tcc_project/src/core/base_types/result.dart';
import 'package:hr_tcc_project/src/shared/comments/domain/usecases/toggle_comment_like.dart';
import '../repositories/news_repository.dart';

class ToggleNewsCommentLikeUsecase implements ToggleCommentLikeUsecase {
  final NewsRepository repository;

  ToggleNewsCommentLikeUsecase(this.repository);

  @override
  Future<Result<bool>> call({
    required int entityId,
    required int commentId,
  }) async {
    return await repository.toggleNewsCommentLike(entityId, commentId);
  }
}
