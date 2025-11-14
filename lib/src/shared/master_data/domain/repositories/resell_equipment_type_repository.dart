import '../../../../core/domain/entities/resell_equipment_type.dart';
import '../../../../core/types/result.dart';

abstract class ResellEquipmentTypeRepository {
  Future<Result<List<ResellEquipmentType>>> getResellEquipmentTypes();
}
