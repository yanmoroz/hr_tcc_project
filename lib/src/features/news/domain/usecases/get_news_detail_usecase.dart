import 'package:hr_tcc_project/src/core/base_types/result.dart';
import '../entities/news_detail.dart';
import '../repositories/news_repository.dart';

class GetNewsDetailUsecase {
  final NewsRepository repository;

  GetNewsDetailUsecase(this.repository);

  Future<Result<NewsDetail>> call(int newsId) async {
    return await repository.getNewsDetail(newsId);
  }
}
