import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetUnplannedTrainingContractorsUsecase {
  final UnplannedTrainingContractorRepository unplannedTrainingContractorRepository;

  GetUnplannedTrainingContractorsUsecase(this.unplannedTrainingContractorRepository);

  Future<Either<NetworkException, List<UnplannedTrainingContractor>>> call() async {
    return await unplannedTrainingContractorRepository.getUnplannedTrainingContractors();
  }
}
