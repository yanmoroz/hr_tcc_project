import 'package:hr_tcc_project/src/core/types/result.dart';
import '../entities/comment.dart';

abstract class CommentRepository {
  Future<Result<List<Comment>>> getComments(int discountId);

  Future<Result<Comment>> addComment({
    required int discountId,
    required String content,
    int? parent,
    List<int>? attachments,
  });

  Future<Result<List<int>>> deleteComment({
    required int discountId,
    required int commentId,
  });
}
