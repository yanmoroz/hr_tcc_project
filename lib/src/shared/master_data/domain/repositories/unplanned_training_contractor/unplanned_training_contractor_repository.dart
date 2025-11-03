import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';

abstract class UnplannedTrainingContractorRepository {
  Future<Result<List<UnplannedTrainingContractor>>> getUnplannedTrainingContractors();
}
