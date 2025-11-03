import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class KpDiscountSourceRepository {
  Future<Result<List<KpDiscountSource>>> getKpDiscountSources();
}
