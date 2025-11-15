import '../../../../core/base_types/result.dart';

import '../entities/kp_discount_category.dart';
import '../repositories/discount_repository.dart';

class GetKpDiscountCategoriesUsecase {
  final DiscountRepository repository;

  GetKpDiscountCategoriesUsecase(this.repository);

  Future<Result<List<KpDiscountCategory>>> call() async {
    return await repository.getKpDiscountCategories();
  }
}
