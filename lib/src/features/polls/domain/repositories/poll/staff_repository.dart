import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class StaffRepository {
  Future<Result<List<StaffItem>>> getStaff({required StaffTarget target, String? search});
}
