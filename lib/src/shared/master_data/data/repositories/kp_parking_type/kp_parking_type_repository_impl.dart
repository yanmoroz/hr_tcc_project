import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class KpParkingTypeRepositoryImpl implements KpParkingTypeRepository {
  final KpParkingTypeRemoteDataSource _remoteDataSource;

  KpParkingTypeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<KpParkingType>>> getKpParkingTypes() async {
    final result = await _remoteDataSource.getKpParkingTypes();

    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => model.toDomain()).toList()));
  }
}
