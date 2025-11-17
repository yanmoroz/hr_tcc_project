import '../../../../core/base_types/result.dart';
import '../repositories/news_repository.dart';

class ToggleNewsLikeUsecase {
  final NewsRepository repository;

  ToggleNewsLikeUsecase(this.repository);

  Future<Result<bool>> call(int newsId) async {
    return await repository.toggleNewsLike(newsId);
  }
}
