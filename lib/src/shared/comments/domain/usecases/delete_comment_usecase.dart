import 'package:hr_tcc_project/src/core/types/result.dart';
import '../repositories/comment_repository.dart';

class DeleteCommentUsecase {
  final CommentRepository repository;

  DeleteCommentUsecase(this.repository);

  Future<Result<List<int>>> call({
    required int entityId,
    required int commentId,
  }) async {
    return await repository.deleteComment(
      entityId: entityId,
      commentId: commentId,
    );
  }
}