import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class ParkingTypeRepositoryImpl implements ParkingTypeRepository {
  final ParkingTypeRemoteDataSource _remoteDataSource;

  ParkingTypeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<ParkingType>>> getParkingTypes() async {
    final result = await _remoteDataSource.getParkingTypes();

    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => model.toDomain()).toList()));
  }
}
