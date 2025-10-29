import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';

abstract class ReferralProgramVacationRepository {
  Future<Either<NetworkException, List<ReferralProgramVacation>>> getReferralProgramVacations();
}
