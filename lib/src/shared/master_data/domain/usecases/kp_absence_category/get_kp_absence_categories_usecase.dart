import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetKpAbsenceCategoriesUsecase {
  final KpAbsenceCategoryRepository kpAbsenceCategoryRepository;

  GetKpAbsenceCategoriesUsecase(this.kpAbsenceCategoryRepository);

  Future<Result<List<KpAbsenceCategory>>> call() async {
    return await kpAbsenceCategoryRepository.getKpAbsenceCategories();
  }
}
