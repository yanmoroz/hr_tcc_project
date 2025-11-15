import 'package:hr_tcc_project/src/core/base_types/result.dart';
import '../entities/comment.dart';
import '../repositories/comment_repository.dart';

class AddCommentUsecase {
  final CommentRepository repository;

  AddCommentUsecase(this.repository);

  Future<Result<Comment>> call({
    required int entityId,
    required String content,
    int? parent,
    List<int>? attachments,
  }) async {
    return await repository.addComment(
      entityId: entityId,
      content: content,
      parent: parent,
      attachments: attachments,
    );
  }
}
