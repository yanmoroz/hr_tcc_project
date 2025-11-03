import '../../../../../core/types/result.dart';

import '../../domain.dart';
import '../../domain.dart';

class GetKpNewsCategoriesUsecase {
  final KpNewsCategoryRepository kpNewsCategoryRepository;

  GetKpNewsCategoriesUsecase(this.kpNewsCategoryRepository);

  Future<Result<List<KpNewsCategory>>> call() async {
    return await kpNewsCategoryRepository.getKpNewsCategories();
  }
}
