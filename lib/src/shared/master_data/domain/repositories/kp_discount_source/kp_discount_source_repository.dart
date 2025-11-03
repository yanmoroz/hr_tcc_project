import '../../../../../core/types/result.dart';

import '../../domain.dart';

abstract class KpDiscountSourceRepository {
  Future<Result<List<KpDiscountSource>>> getKpDiscountSources();
}
