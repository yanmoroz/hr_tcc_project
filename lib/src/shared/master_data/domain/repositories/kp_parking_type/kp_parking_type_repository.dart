import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class KpParkingTypeRepository {
  Future<Result<List<KpParkingType>>> getKpParkingTypes();
}
