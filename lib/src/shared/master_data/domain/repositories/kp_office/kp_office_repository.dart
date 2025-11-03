import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class KpOfficeRepository {
  Future<Result<List<KpOffice>>> getKpOffices();
}
