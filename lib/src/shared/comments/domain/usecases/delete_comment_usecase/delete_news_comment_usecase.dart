import '../../../../../core/base_types/result.dart';
import '../../repositories/comment_repository.dart';
import 'delete_comment_usecase.dart';

class DeleteNewsCommentUsecase extends DeleteCommentUsecase {
  final CommentRepository repository;

  DeleteNewsCommentUsecase(this.repository);

  @override
  Future<Result<List<int>>> call({
    required int entityId,
    required int commentId,
  }) async {
    return await repository.deleteNewsComment(
      newsId: entityId,
      commentId: commentId,
    );
  }
}
