import '../../../../../core/types/result.dart';

import '../../domain.dart';
import '../../domain.dart';

class GetKpDiscountSourcesUsecase {
  final KpDiscountSourceRepository kpDiscountSourceRepository;

  GetKpDiscountSourcesUsecase(this.kpDiscountSourceRepository);

  Future<Result<List<KpDiscountSource>>> call() async {
    return await kpDiscountSourceRepository.getKpDiscountSources();
  }
}
