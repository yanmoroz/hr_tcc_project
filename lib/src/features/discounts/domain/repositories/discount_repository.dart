import '../../../../core/base_types/result.dart';
import '../entities/discount.dart';
import '../entities/discount_detail.dart';
import '../entities/kp_discount_category.dart';
import '../entities/kp_discount_source.dart';
import '../results/get_discount_stats_result.dart';

abstract class DiscountRepository {
  Future<Result<List<Discount>>> getDiscounts({
    required int category,
    required int source,
    required int page,
  });
  Future<Result<DiscountDetail>> getDiscountDetail(int id);
  Future<Result<GetDiscountStatsResult>> getDiscountStats(int id);
  Future<Result<List<KpDiscountSource>>> getKpDiscountSources();
  Future<Result<List<KpDiscountCategory>>> getKpDiscountCategories();
  Future<Result<bool>> toggleDiscountLike(int discountId);
}
