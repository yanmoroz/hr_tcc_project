import '../../../../core/types/result.dart';

import '../domain.dart';

class GetSystemStatusGroupsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetSystemStatusGroupsUsecase(this.coreDictionariesRepository);

  Future<Result<List<SystemStatusGroup>>> call() async {
    return await coreDictionariesRepository.getSystemStatusGroups();
  }
}
