import 'package:hr_tcc_project/src/core/types/result.dart';
import '../entities/discount.dart';
import '../entities/discount_detail.dart';

abstract class DiscountRepository {
  Future<Result<List<Discount>>> getDiscounts({required int category, required int source, required int page});

  Future<Result<DiscountDetail>> getDiscountDetail(int id);

  Future<Result<({int likeCount, bool like, int commentCount})>> getDiscountStats(int id);
}
