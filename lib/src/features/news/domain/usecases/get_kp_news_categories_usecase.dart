import '../../../../core/base_types/result.dart';

import '../entities/kp_news_category.dart';
import '../repositories/news_repository.dart';

class GetKpNewsCategoriesUsecase {
  final NewsRepository newsRepository;

  GetKpNewsCategoriesUsecase(this.newsRepository);

  Future<Result<List<KpNewsCategory>>> call() async {
    return await newsRepository.getKpNewsCategories();
  }
}
