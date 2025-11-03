import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class ViolationSecurityLevelRepository {
  Future<Result<List<ViolationSecurityLevel>>> getViolationSecurityLevels();
}
