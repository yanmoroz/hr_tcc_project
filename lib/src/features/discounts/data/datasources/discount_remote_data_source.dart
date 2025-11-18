import '../../../../core/base_types/result.dart';
import '../models/discount_detail_model.dart';
import '../models/discount_list_response_model.dart';
import '../models/kp_discount_category_model.dart';
import '../models/kp_discount_source_model.dart';
import '../models/stats_response_model.dart';

abstract class DiscountRemoteDataSource {
  Future<Result<DiscountListResponseModel>> getDiscounts({
    required int category,
    required int source,
    required int page,
  });
  Future<Result<DiscountDetailModel>> getDiscountDetail(int id);
  Future<Result<StatsResponseModel>> getDiscountStats(int id);
  Future<Result<List<KpDiscountSourceModel>>> getKpDiscountSources();
  Future<Result<List<KpDiscountCategoryModel>>> getKpDiscountCategories();
  Future<Result<bool>> toggleDiscountLike(int discountId);
}
