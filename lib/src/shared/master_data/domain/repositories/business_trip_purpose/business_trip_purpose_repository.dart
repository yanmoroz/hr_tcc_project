import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';

abstract class BusinessTripPurposeRepository {
  Future<Either<NetworkException, List<BusinessTripPurpose>>> getBusinessTripPurposes();
}

