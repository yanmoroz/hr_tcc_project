import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetResellEquipmentTypesUsecase {
  final ResellEquipmentTypeRepository resellEquipmentTypeRepository;

  GetResellEquipmentTypesUsecase(this.resellEquipmentTypeRepository);

  Future<Either<NetworkException, List<ResellEquipmentType>>> call() async {
    return await resellEquipmentTypeRepository.getResellEquipmentTypes();
  }
}
