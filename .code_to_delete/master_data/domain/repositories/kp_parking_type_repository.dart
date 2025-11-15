import '../../../../core/types/result.dart';

import '../domain.dart';

abstract class KpParkingTypeRepository {
  Future<Result<List<KpParkingType>>> getKpParkingTypes();
}
