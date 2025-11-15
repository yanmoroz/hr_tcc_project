import '../../../../core/base_types/result.dart';
import '../entities/resell_equipment_type.dart';
import '../repositories/resell_repository.dart';

class GetResellEquipmentTypesUsecase {
  final ResellRepository resellRepository;

  GetResellEquipmentTypesUsecase(this.resellRepository);

  Future<Result<List<ResellEquipmentType>>> call() async {
    return await resellRepository.getResellEquipmentTypes();
  }
}
