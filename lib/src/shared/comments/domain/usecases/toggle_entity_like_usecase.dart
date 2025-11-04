import 'package:hr_tcc_project/src/core/types/result.dart';
import '../repositories/like_repository.dart';

class ToggleEntityLikeUsecase {
  final LikeRepository repository;

  ToggleEntityLikeUsecase(this.repository);

  Future<Result<bool>> call(int entityId) async {
    return await repository.toggleEntityLike(entityId);
  }
}