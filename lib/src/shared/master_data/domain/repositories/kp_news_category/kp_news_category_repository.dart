import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class KpNewsCategoryRepository {
  Future<Result<List<KpNewsCategory>>> getKpNewsCategories();
}
