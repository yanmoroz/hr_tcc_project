import 'package:hr_tcc_project/src/core/types/result.dart';
import '../entities/comment.dart';
import '../repositories/comment_repository.dart';

class GetCommentsUsecase {
  final CommentRepository repository;

  GetCommentsUsecase(this.repository);

  Future<Result<List<Comment>>> call(int entityId) async {
    return await repository.getComments(entityId);
  }
}