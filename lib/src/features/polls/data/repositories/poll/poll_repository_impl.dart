import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class PollRepositoryImpl implements PollRepository {
  final PollRemoteDataSource _remoteDataSource;

  PollRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<Poll>>> getPolls({int? status, required int page}) async {
    final result = await _remoteDataSource.getPolls(status: status, page: page);

    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => model.toDomain()).toList()));
  }
}
