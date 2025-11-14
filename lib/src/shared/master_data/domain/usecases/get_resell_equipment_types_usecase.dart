import '../../../../core/domain/entities/resell_equipment_type.dart';
import '../../../../core/types/result.dart';

import '../domain.dart';

class GetResellEquipmentTypesUsecase {
  final ResellEquipmentTypeRepository resellEquipmentTypeRepository;

  GetResellEquipmentTypesUsecase(this.resellEquipmentTypeRepository);

  Future<Result<List<ResellEquipmentType>>> call() async {
    return await resellEquipmentTypeRepository.getResellEquipmentTypes();
  }
}
