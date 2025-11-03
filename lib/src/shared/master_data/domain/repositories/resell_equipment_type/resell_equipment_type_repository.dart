import '../../../../../core/types/result.dart';

import '../../domain.dart';

abstract class ResellEquipmentTypeRepository {
  Future<Result<List<ResellEquipmentType>>> getResellEquipmentTypes();
}
