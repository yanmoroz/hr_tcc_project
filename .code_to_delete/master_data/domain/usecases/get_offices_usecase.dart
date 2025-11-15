import '../../../../core/types/result.dart';

import '../domain.dart';

class GetOfficesUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetOfficesUsecase(this.coreDictionariesRepository);

  Future<Result<List<Office>>> call() async {
    return await coreDictionariesRepository.getOffices();
  }
}
