import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class ReferralProgramCandidateRepositoryImpl with BaseRepository implements ReferralProgramCandidateRepository {
  final ReferralProgramCandidateRemoteDataSource _remoteDataSource;

  ReferralProgramCandidateRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ReferralProgramCandidate>>> getReferralProgramCandidates() async {
    final result = await _remoteDataSource.getReferralProgramCandidates();

    return mapResultList(result, (model) => model.toDomain());
  }
}
