import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetKpAbsenceCategoriesUsecase {
  final KpAbsenceCategoryRepository kpAbsenceCategoryRepository;

  GetKpAbsenceCategoriesUsecase(this.kpAbsenceCategoryRepository);

  Future<Either<NetworkException, List<KpAbsenceCategory>>> call() async {
    return await kpAbsenceCategoryRepository.getKpAbsenceCategories();
  }
}
