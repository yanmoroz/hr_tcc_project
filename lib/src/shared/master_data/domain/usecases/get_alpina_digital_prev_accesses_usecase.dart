import '../../../../core/types/result.dart';

import '../domain.dart';

class GetAlpinaDigitalPrevAccessesUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetAlpinaDigitalPrevAccessesUsecase(this.coreDictionariesRepository);

  Future<Result<List<AlpinaDigitalPrevAccess>>> call() async {
    return await coreDictionariesRepository.getAlpinaDigitalPrevAccess();
  }
}
