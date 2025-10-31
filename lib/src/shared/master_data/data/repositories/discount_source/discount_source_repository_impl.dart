import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class DiscountSourceRepositoryImpl implements DiscountSourceRepository {
  final DiscountSourceRemoteDataSource _remoteDataSource;

  DiscountSourceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<DiscountSource>>> getDiscountSources() async {
    final result = await _remoteDataSource.getDiscountSources();

    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => model.toDomain()).toList()));
  }
}
