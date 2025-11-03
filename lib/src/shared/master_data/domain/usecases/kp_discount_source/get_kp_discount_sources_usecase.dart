import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetKpDiscountSourcesUsecase {
  final KpDiscountSourceRepository kpDiscountSourceRepository;

  GetKpDiscountSourcesUsecase(this.kpDiscountSourceRepository);

  Future<Result<List<KpDiscountSource>>> call() async {
    return await kpDiscountSourceRepository.getKpDiscountSources();
  }
}
