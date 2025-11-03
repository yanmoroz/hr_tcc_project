import '../../../../../core/types/result.dart';

import '../../domain.dart';
import '../../domain.dart';

class GetApplicationFormsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetApplicationFormsUsecase(this.coreDictionariesRepository);

  Future<Result<List<ApplicationForm>>> call() async {
    return await coreDictionariesRepository.getApplicationForms();
  }
}
