import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetResellEquipmentTypesUsecase {
  final ResellEquipmentTypeRepository resellEquipmentTypeRepository;

  GetResellEquipmentTypesUsecase(this.resellEquipmentTypeRepository);

  Future<Result<List<ResellEquipmentType>>> call() async {
    return await resellEquipmentTypeRepository.getResellEquipmentTypes();
  }
}
