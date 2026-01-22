import '../../../../core/base_types/result.dart';
import '../models/requests/add_comment_request_model.dart';
import '../models/responses/comment_list_response_model.dart';
import '../models/responses/comment_model.dart';

abstract class CommentRemoteDataSource {
  Future<Result<CommentListResponseModel>> getNewsComments(int newsId);

  Future<Result<CommentListResponseModel>> getDiscountComments(int discountId);

  Future<Result<CommentModel>> addNewsComment(
    int newsId,
    AddCommentRequestModel request,
  );

  Future<Result<CommentModel>> addDiscountComment(
    int discountId,
    AddCommentRequestModel request,
  );

  Future<Result<List<int>>> deleteNewsComment(int newsId, int commentId);

  Future<Result<List<int>>> deleteDiscountComment(
    int discountId,
    int commentId,
  );

  Future<Result<bool>> toggleNewsCommentLike(int newsId, int commentId);

  Future<Result<bool>> toggleDiscountCommentLike(int discountId, int commentId);
}
