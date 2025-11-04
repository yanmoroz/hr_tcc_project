import 'package:hr_tcc_project/src/core/types/result.dart';
import '../repositories/like_repository.dart';

class ToggleDiscountLikeUsecase {
  final LikeRepository repository;

  ToggleDiscountLikeUsecase(this.repository);

  Future<Result<bool>> call(int discountId) async {
    return await repository.toggleDiscountLike(discountId);
  }
}
