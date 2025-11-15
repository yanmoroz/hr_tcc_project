import 'package:hr_tcc_project/src/core/base_types/result.dart';
import '../repositories/like_repository.dart';

class ToggleCommentLikeUsecase {
  final LikeRepository repository;

  ToggleCommentLikeUsecase(this.repository);

  Future<Result<bool>> call({
    required int entityId,
    required int commentId,
  }) async {
    return await repository.toggleCommentLike(
      entityId: entityId,
      commentId: commentId,
    );
  }
}
