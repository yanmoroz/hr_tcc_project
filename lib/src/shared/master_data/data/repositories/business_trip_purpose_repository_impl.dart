import '../../../../core/types/result.dart';

import '../../../../core/base_repository.dart';
import '../../domain/domain.dart';
import '../data.dart';

class BusinessTripPurposeRepositoryImpl with BaseRepository implements BusinessTripPurposeRepository {
  final BusinessTripPurposeRemoteDataSource _remoteDataSource;

  BusinessTripPurposeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<BusinessTripPurpose>>> getBusinessTripPurposes() async {
    final result = await _remoteDataSource.getBusinessTripPurposes();

    return mapResultList(result, (model) => model.toDomain());
  }
}
