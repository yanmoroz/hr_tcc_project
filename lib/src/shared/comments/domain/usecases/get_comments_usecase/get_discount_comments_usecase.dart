import '../../../../../core/base_types/result.dart';
import '../../entities/comment.dart';
import '../../repositories/comment_repository.dart';
import 'get_comments_usecase.dart';

class GetDiscountCommentsUsecase extends GetCommentsUsecase {
  final CommentRepository repository;

  GetDiscountCommentsUsecase(this.repository);

  @override
  Future<Result<List<Comment>>> call(int entityId) async {
    return await repository.getDiscountComments(entityId);
  }
}
