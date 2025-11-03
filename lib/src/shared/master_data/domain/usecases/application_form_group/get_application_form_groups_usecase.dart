import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetApplicationFormGroupsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetApplicationFormGroupsUsecase(this.coreDictionariesRepository);

  Future<Result<List<ApplicationFormGroup>>> call() async {
    return await coreDictionariesRepository.getApplicationFormGroups();
  }
}
