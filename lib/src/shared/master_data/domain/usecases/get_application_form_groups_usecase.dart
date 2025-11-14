import '../../../../core/types/result.dart';

import '../domain.dart';

class GetApplicationFormGroupsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetApplicationFormGroupsUsecase(this.coreDictionariesRepository);

  Future<Result<List<ApplicationFormGroup>>> call() async {
    return await coreDictionariesRepository.getApplicationFormGroups();
  }
}
