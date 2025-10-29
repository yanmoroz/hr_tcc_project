import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetTripPurposesUsecase {
  final CoreDictionariesRepository coreDictionariesRepository;

  GetTripPurposesUsecase(this.coreDictionariesRepository);

  Future<Either<NetworkException, List<TripPurpose>>> call() async {
    return await coreDictionariesRepository.getTripPurposes();
  }
}
