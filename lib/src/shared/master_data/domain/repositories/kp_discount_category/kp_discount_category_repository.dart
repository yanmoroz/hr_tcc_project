import '../../../../../core/types/result.dart';

import '../../domain.dart';

abstract class KpDiscountCategoryRepository {
  Future<Result<List<KpDiscountCategory>>> getKpDiscountCategories();
}
