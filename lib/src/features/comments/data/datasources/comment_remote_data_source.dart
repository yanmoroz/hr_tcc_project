import '../../../../core/base_types/result.dart';
import '../models/add_comment_request.dart';
import '../models/comment_list_response_model.dart';
import '../models/comment_model.dart';
import '../models/comment_remove_response_model.dart';

abstract class CommentRemoteDataSource {
  Future<Result<CommentListResponseModel>> getNewsComments(int newsId);

  Future<Result<CommentListResponseModel>> getDiscountComments(int discountId);

  Future<Result<CommentModel>> addNewsComment(
    int newsId,
    AddCommentRequest request,
  );

  Future<Result<CommentModel>> addDiscountComment(
    int discountId,
    AddCommentRequest request,
  );

  Future<Result<CommentRemoveResponseModel>> deleteNewsComment(
    int newsId,
    int commentId,
  );

  Future<Result<CommentRemoveResponseModel>> deleteDiscountComment(
    int discountId,
    int commentId,
  );

  Future<Result<bool>> toggleNewsCommentLike(int newsId, int commentId);

  Future<Result<bool>> toggleDiscountCommentLike(int discountId, int commentId);
}
