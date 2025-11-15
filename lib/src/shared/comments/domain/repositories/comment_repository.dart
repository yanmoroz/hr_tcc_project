import 'package:hr_tcc_project/src/core/base_types/result.dart';
import '../entities/comment.dart';

abstract class CommentRepository {
  Future<Result<List<Comment>>> getComments(int entityId);

  Future<Result<Comment>> addComment({
    required int entityId,
    required String content,
    int? parent,
    List<int>? attachments,
  });

  Future<Result<List<int>>> deleteComment({
    required int entityId,
    required int commentId,
  });
}
