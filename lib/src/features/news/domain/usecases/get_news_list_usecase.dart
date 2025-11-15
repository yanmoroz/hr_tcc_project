import 'package:hr_tcc_project/src/core/base_types/result.dart';
import '../entities/news_item.dart';
import '../repositories/news_repository.dart';

class GetNewsListUsecase {
  final NewsRepository repository;

  GetNewsListUsecase(this.repository);

  Future<Result<List<NewsItem>>> call({
    int? category,
    String? search,
    required int page,
  }) async {
    return await repository.getNewsList(
      category: category,
      search: search,
      page: page,
    );
  }
}
