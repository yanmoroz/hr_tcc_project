import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class ResellEquipmentTypeRepository {
  Future<Result<List<ResellEquipmentType>>> getResellEquipmentTypes();
}
