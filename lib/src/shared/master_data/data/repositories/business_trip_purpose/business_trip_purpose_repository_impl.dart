import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class BusinessTripPurposeRepositoryImpl implements BusinessTripPurposeRepository {
  final BusinessTripPurposeRemoteDataSource _remoteDataSource;

  BusinessTripPurposeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<BusinessTripPurpose>>> getBusinessTripPurposes() async {
    final result = await _remoteDataSource.getBusinessTripPurposes();

    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toDomain()).toList()),
    );
  }
}

