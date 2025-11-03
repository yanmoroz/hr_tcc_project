import '../../../../../core/types/result.dart';

import '../../domain.dart';

abstract class KpOfficeRepository {
  Future<Result<List<KpOffice>>> getKpOffices();
}
