import '../../../../../core/types/result.dart';

import '../../domain.dart';

class GetKpParkingTypesUsecase {
  final KpParkingTypeRepository kpParkingTypeRepository;

  GetKpParkingTypesUsecase(this.kpParkingTypeRepository);

  Future<Result<List<KpParkingType>>> call() async {
    return await kpParkingTypeRepository.getKpParkingTypes();
  }
}
