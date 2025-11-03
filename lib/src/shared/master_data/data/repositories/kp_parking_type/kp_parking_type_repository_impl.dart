import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class KpParkingTypeRepositoryImpl with BaseRepository implements KpParkingTypeRepository {
  final KpParkingTypeRemoteDataSource _remoteDataSource;

  KpParkingTypeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<KpParkingType>>> getKpParkingTypes() async {
    final result = await _remoteDataSource.getKpParkingTypes();

    return mapResultList(result, (model) => model.toDomain());
  }
}
