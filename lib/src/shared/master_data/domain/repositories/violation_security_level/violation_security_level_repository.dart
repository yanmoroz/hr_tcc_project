import '../../../../../core/types/result.dart';

import '../../domain.dart';

abstract class ViolationSecurityLevelRepository {
  Future<Result<List<ViolationSecurityLevel>>> getViolationSecurityLevels();
}
