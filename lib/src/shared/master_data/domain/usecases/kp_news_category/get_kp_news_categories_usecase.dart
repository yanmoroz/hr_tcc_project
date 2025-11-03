import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetKpNewsCategoriesUsecase {
  final KpNewsCategoryRepository kpNewsCategoryRepository;

  GetKpNewsCategoriesUsecase(this.kpNewsCategoryRepository);

  Future<Result<List<KpNewsCategory>>> call() async {
    return await kpNewsCategoryRepository.getKpNewsCategories();
  }
}
