import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class KpAbsenceCategoryRepository {
  Future<Result<List<KpAbsenceCategory>>> getKpAbsenceCategories();
}
