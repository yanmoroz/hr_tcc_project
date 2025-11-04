import 'package:hr_tcc_project/src/core/types/result.dart';

abstract class LikeRepository {
  Future<Result<bool>> toggleDiscountLike(int discountId);

  Future<Result<bool>> toggleCommentLike({
    required int discountId,
    required int commentId,
  });
}
