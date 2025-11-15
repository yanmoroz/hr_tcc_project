import '../../../../core/base_types/result.dart';

import '../entities/kp_discount_source.dart';
import '../repositories/discount_repository.dart';

class GetKpDiscountSourcesUsecase {
  final DiscountRepository repository;

  GetKpDiscountSourcesUsecase(this.repository);

  Future<Result<List<KpDiscountSource>>> call() async {
    return await repository.getKpDiscountSources();
  }
}
