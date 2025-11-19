import '../../../../core/base_types/result.dart';
import '../repositories/news_repository.dart';
import '../results/get_news_stats_results.dart';

class GetNewsStatsUsecase {
  final NewsRepository repository;

  GetNewsStatsUsecase(this.repository);

  Future<Result<GetNewsStatsResults>> call(int newsId) async {
    return await repository.getNewsStats(newsId);
  }
}
