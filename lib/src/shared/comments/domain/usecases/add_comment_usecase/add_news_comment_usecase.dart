import '../../../../../core/base_types/result.dart';
import '../../entities/comment.dart';
import '../../repositories/comment_repository.dart';
import 'add_comment_usecase.dart';

class AddNewsCommentUsecase extends AddCommentUsecase {
  final CommentRepository repository;

  AddNewsCommentUsecase(this.repository);

  @override
  Future<Result<Comment>> call({
    required int entityId,
    required String content,
    int? parent,
    List<int>? attachments,
  }) async {
    return await repository.addNewsComment(
      newsId: entityId,
      content: content,
      parent: parent,
      attachments: attachments,
    );
  }
}
