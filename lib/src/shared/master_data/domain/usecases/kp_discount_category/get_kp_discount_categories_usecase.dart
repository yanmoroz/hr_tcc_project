import '../../../../../core/types/result.dart';

import '../../domain.dart';

class GetKpDiscountCategoriesUsecase {
  final KpDiscountCategoryRepository kpDiscountCategoryRepository;

  GetKpDiscountCategoriesUsecase(this.kpDiscountCategoryRepository);

  Future<Result<List<KpDiscountCategory>>> call() async {
    return await kpDiscountCategoryRepository.getKpDiscountCategories();
  }
}
