import '../../../../../core/types/result.dart';

import '../../domain.dart';
import '../../domain.dart';

class GetKpAbsenceCategoriesUsecase {
  final KpAbsenceCategoryRepository kpAbsenceCategoryRepository;

  GetKpAbsenceCategoriesUsecase(this.kpAbsenceCategoryRepository);

  Future<Result<List<KpAbsenceCategory>>> call() async {
    return await kpAbsenceCategoryRepository.getKpAbsenceCategories();
  }
}
