import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class BusinessTripPurposeRepositoryImpl with BaseRepository implements BusinessTripPurposeRepository {
  final BusinessTripPurposeRemoteDataSource _remoteDataSource;

  BusinessTripPurposeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<BusinessTripPurpose>>> getBusinessTripPurposes() async {
    final result = await _remoteDataSource.getBusinessTripPurposes();

    return mapResultList(result, (model) => model.toDomain());
  }
}

