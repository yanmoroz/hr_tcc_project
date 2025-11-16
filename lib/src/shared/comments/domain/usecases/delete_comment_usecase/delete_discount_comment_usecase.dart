import '../../../../../core/base_types/result.dart';
import '../../repositories/comment_repository.dart';
import 'delete_comment_usecase.dart';

class DeleteDiscountCommentUsecase extends DeleteCommentUsecase {
  final CommentRepository repository;

  DeleteDiscountCommentUsecase(this.repository);

  @override
  Future<Result<List<int>>> call({
    required int entityId,
    required int commentId,
  }) async {
    return await repository.deleteDiscountComment(
      discountId: entityId,
      commentId: commentId,
    );
  }
}
