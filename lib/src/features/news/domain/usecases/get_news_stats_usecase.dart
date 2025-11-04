import 'package:hr_tcc_project/src/core/types/result.dart';
import '../entities/news_stats.dart';
import '../repositories/news_repository.dart';

class GetNewsStatsUsecase {
  final NewsRepository repository;

  GetNewsStatsUsecase(this.repository);

  Future<Result<NewsStats>> call(int newsId) async {
    return await repository.getNewsStats(newsId);
  }
}