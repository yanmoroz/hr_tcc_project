import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetSystemStatusesUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetSystemStatusesUsecase(this.coreDictionariesRepository);

  Future<Result<List<SystemStatus>>> call() async {
    return await coreDictionariesRepository.getSystemStatuses();
  }
}
