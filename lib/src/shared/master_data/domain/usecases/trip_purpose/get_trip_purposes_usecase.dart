import '../../../../../core/types/result.dart';

import '../../domain.dart';

class GetTripPurposesUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetTripPurposesUsecase(this.coreDictionariesRepository);

  Future<Result<List<TripPurpose>>> call() async {
    return await coreDictionariesRepository.getTripPurposes();
  }
}
