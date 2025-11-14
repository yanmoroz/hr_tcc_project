import '../../../../core/types/result.dart';

import '../domain.dart';

abstract class BusinessTripPurposeRepository {
  Future<Result<List<BusinessTripPurpose>>> getBusinessTripPurposes();
}
