import '../../../../../core/types/result.dart';

import '../../domain.dart';
import '../../domain.dart';

class GetBusinessTripPurposesUsecase {
  final BusinessTripPurposeRepository businessTripPurposeRepository;

  GetBusinessTripPurposesUsecase(this.businessTripPurposeRepository);

  Future<Result<List<BusinessTripPurpose>>> call() async {
    return await businessTripPurposeRepository.getBusinessTripPurposes();
  }
}

