import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class KpDiscountCategoryRepository {
  Future<Result<List<KpDiscountCategory>>> getKpDiscountCategories();
}
