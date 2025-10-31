import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetKpParkingTypesUsecase {
  final KpParkingTypeRepository kpParkingTypeRepository;

  GetKpParkingTypesUsecase(this.kpParkingTypeRepository);

  Future<Either<NetworkException, List<KpParkingType>>> call() async {
    return await kpParkingTypeRepository.getKpParkingTypes();
  }
}
