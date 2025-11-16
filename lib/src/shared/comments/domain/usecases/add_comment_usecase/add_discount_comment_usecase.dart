import '../../../../../core/base_types/result.dart';
import '../../entities/comment.dart';
import '../../repositories/comment_repository.dart';
import 'add_comment_usecase.dart';

class AddDiscountCommentUsecase extends AddCommentUsecase {
  final CommentRepository repository;

  AddDiscountCommentUsecase(this.repository);

  @override
  Future<Result<Comment>> call({
    required int entityId,
    required String content,
    int? parent,
    List<int>? attachments,
  }) async {
    return await repository.addDiscountComment(
      discountId: entityId,
      content: content,
      parent: parent,
      attachments: attachments,
    );
  }
}
