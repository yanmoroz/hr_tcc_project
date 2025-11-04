import 'package:hr_tcc_project/src/core/types/result.dart';
import '../repositories/like_repository.dart';

class ToggleCommentLikeUsecase {
  final LikeRepository repository;

  ToggleCommentLikeUsecase(this.repository);

  Future<Result<bool>> call({
    required int discountId,
    required int commentId,
  }) async {
    return await repository.toggleCommentLike(
      discountId: discountId,
      commentId: commentId,
    );
  }
}
