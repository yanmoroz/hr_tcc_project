import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetApplicationFormsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetApplicationFormsUsecase(this.coreDictionariesRepository);

  Future<Result<List<ApplicationForm>>> call() async {
    return await coreDictionariesRepository.getApplicationForms();
  }
}
