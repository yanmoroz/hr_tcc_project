import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetOfficesUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetOfficesUsecase(this.coreDictionariesRepository);

  Future<Result<List<Office>>> call() async {
    return await coreDictionariesRepository.getOffices();
  }
}
