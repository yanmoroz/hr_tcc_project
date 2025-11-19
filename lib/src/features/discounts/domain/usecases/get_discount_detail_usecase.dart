import 'package:hr_tcc_project/src/core/base_types/result.dart';

import '../entities/discount_detail.dart';
import '../repositories/discount_repository.dart';

class GetDiscountDetailUsecase {
  final DiscountRepository repository;

  GetDiscountDetailUsecase(this.repository);

  Future<Result<DiscountDetail>> call(int id) async {
    return await repository.getDiscountDetail(id);
  }
}
