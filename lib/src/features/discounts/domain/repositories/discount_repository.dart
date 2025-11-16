import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../entities/discount.dart';
import '../entities/discount_detail.dart';
import '../entities/kp_discount_category.dart';
import '../entities/kp_discount_source.dart';

abstract class DiscountRepository {
  Future<Result<List<Discount>>> getDiscounts({
    required int category,
    required int source,
    required int page,
  });
  Future<Result<DiscountDetail>> getDiscountDetail(int id);
  Future<Result<({int likeCount, bool like, int commentCount})>>
  getDiscountStats(int id);
  Future<Result<List<KpDiscountSource>>> getKpDiscountSources();
  Future<Result<List<KpDiscountCategory>>> getKpDiscountCategories();
  Future<Result<bool>> toggleDiscountLike(int discountId);
  Future<Result<bool>> toggleDiscountCommentLike(
    int discountId,
    int commentId,
  );
}
