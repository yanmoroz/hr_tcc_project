import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class BusinessTripPurposeRepository {
  Future<Result<List<BusinessTripPurpose>>> getBusinessTripPurposes();
}

