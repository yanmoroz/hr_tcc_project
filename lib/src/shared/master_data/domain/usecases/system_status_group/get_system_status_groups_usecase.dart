import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetSystemStatusGroupsUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetSystemStatusGroupsUsecase(this.coreDictionariesRepository);

  Future<Result<List<SystemStatusGroup>>> call() async {
    return await coreDictionariesRepository.getSystemStatusGroups();
  }
}
