import '../../../../core/base_types/result.dart';
import '../entities/kp_absence_category.dart';
import '../repositories/application_repository.dart';

class GetKpAbsenceCategoriesUsecase {
  final ApplicationRepository _repository;

  GetKpAbsenceCategoriesUsecase(this._repository);

  Future<Result<List<KpAbsenceCategory>>> call() async {
    return await _repository.getKpAbsenceCategories();
  }
}
