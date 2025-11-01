import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';

abstract class StaffRepository {
  Future<Either<NetworkException, List<StaffItem>>> getStaff({required StaffTarget target, String? search});
}
