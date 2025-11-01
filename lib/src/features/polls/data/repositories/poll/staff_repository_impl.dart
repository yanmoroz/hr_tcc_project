import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDataSource _remoteDataSource;

  StaffRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<StaffItem>>> getStaff({required StaffTarget target, String? search}) async {
    final result = await _remoteDataSource.getStaff(target: target, search: search);

    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => model.toDomain()).toList()));
  }
}
