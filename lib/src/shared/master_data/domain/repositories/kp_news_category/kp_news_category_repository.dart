import '../../../../../core/types/result.dart';

import '../../domain.dart';

abstract class KpNewsCategoryRepository {
  Future<Result<List<KpNewsCategory>>> getKpNewsCategories();
}
