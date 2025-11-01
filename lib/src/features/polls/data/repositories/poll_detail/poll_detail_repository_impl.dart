import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class PollDetailRepositoryImpl implements PollDetailRepository {
  final PollDetailRemoteDataSource _remoteDataSource;

  PollDetailRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, PollDetail>> getPollDetail(int id) async {
    final result = await _remoteDataSource.getPollDetail(id);

    return result.fold((failure) => Left(failure), (model) => Right(model.toDomain()));
  }

  @override
  Future<Either<NetworkException, void>> submitPollAnswers({
    required int pollId,
    required PollAnswersRequest request,
  }) async {
    final requestModel = PollAnswersRequestModel(answers: request.answers.map((answer) => answer.toModel()).toList());
    return await _remoteDataSource.submitPollAnswers(pollId: pollId, request: requestModel);
  }
}
