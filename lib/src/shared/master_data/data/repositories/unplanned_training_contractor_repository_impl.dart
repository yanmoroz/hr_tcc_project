import '../../../../core/types/result.dart';

import '../../../../core/data/base_repository.dart';
import '../../domain/domain.dart';
import '../data.dart';

class UnplannedTrainingContractorRepositoryImpl with BaseRepository implements UnplannedTrainingContractorRepository {
  final UnplannedTrainingContractorRemoteDataSource _remoteDataSource;

  UnplannedTrainingContractorRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<UnplannedTrainingContractor>>> getUnplannedTrainingContractors() async {
    final result = await _remoteDataSource.getUnplannedTrainingContractors();

    return mapResultList(result, (model) => model.toDomain());
  }
}
