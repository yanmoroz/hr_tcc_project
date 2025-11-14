import '../../../../core/types/result.dart';

import '../domain.dart';

abstract class KpAbsenceCategoryRepository {
  Future<Result<List<KpAbsenceCategory>>> getKpAbsenceCategories();
}
