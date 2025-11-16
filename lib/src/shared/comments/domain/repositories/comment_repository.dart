import '../../../../core/base_types/result.dart';
import '../entities/comment.dart';

abstract class CommentRepository {
  Future<Result<List<Comment>>> getNewsComments(int newsId);

  Future<Result<List<Comment>>> getDiscountComments(int discountId);

  Future<Result<Comment>> addNewsComment({
    required int newsId,
    required String content,
    int? parent,
    List<int>? attachments,
  });

  Future<Result<Comment>> addDiscountComment({
    required int discountId,
    required String content,
    int? parent,
    List<int>? attachments,
  });

  Future<Result<List<int>>> deleteNewsComment({
    required int newsId,
    required int commentId,
  });

  Future<Result<List<int>>> deleteDiscountComment({
    required int discountId,
    required int commentId,
  });
}
