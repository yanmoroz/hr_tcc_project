import '../../../../../core/types/result.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../domain/domain.dart';
import '../../../domain/domain.dart';
import '../../data.dart';
import '../../data.dart';

class KpParkingTypeRepositoryImpl with BaseRepository implements KpParkingTypeRepository {
  final KpParkingTypeRemoteDataSource _remoteDataSource;

  KpParkingTypeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<KpParkingType>>> getKpParkingTypes() async {
    final result = await _remoteDataSource.getKpParkingTypes();

    return mapResultList(result, (model) => model.toDomain());
  }
}
