import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';

abstract class AbsenceCategoryRepository {
  Future<Either<NetworkException, List<AbsenceCategory>>> getAbsenceCategories();
}
