import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../repositories/discount_repository.dart';

class ToggleDiscountLikeUsecase {
  final DiscountRepository repository;

  ToggleDiscountLikeUsecase(this.repository);

  Future<Result<bool>> call(int discountId) async {
    return await repository.toggleDiscountLike(discountId);
  }
}
