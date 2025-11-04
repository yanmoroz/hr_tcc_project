import 'package:hr_tcc_project/src/core/types/result.dart';
import 'package:hr_tcc_project/src/shared/comments/domain/domain.dart';

class ToggleNewsLikeUsecase {
  final LikeRepository repository;

  ToggleNewsLikeUsecase(this.repository);

  Future<Result<bool>> call(int newsId) async {
    return await repository.toggleEntityLike(newsId);
  }
}