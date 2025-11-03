import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetKpDiscountCategoriesUsecase {
  final KpDiscountCategoryRepository kpDiscountCategoryRepository;

  GetKpDiscountCategoriesUsecase(this.kpDiscountCategoryRepository);

  Future<Result<List<KpDiscountCategory>>> call() async {
    return await kpDiscountCategoryRepository.getKpDiscountCategories();
  }
}
