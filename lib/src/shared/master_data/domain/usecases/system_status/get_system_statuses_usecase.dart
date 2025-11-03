import '../../../../../core/types/result.dart';

import '../../domain.dart';
import '../../domain.dart';

class GetSystemStatusesUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetSystemStatusesUsecase(this.coreDictionariesRepository);

  Future<Result<List<SystemStatus>>> call() async {
    return await coreDictionariesRepository.getSystemStatuses();
  }
}
