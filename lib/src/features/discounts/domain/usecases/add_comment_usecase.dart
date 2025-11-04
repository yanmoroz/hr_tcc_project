import 'package:hr_tcc_project/src/core/types/result.dart';
import '../entities/comment.dart';
import '../repositories/comment_repository.dart';

class AddCommentUsecase {
  final CommentRepository repository;

  AddCommentUsecase(this.repository);

  Future<Result<Comment>> call({
    required int discountId,
    required String content,
    int? parent,
    List<int>? attachments,
  }) async {
    return await repository.addComment(
      discountId: discountId,
      content: content,
      parent: parent,
      attachments: attachments,
    );
  }
}
