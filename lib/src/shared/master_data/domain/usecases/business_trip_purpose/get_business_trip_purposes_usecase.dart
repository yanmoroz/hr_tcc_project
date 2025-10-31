import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetBusinessTripPurposesUsecase {
  final BusinessTripPurposeRepository businessTripPurposeRepository;

  GetBusinessTripPurposesUsecase(this.businessTripPurposeRepository);

  Future<Either<NetworkException, List<BusinessTripPurpose>>> call() async {
    return await businessTripPurposeRepository.getBusinessTripPurposes();
  }
}

