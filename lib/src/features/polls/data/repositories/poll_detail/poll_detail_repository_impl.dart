import '../../../../../core/base_types/result.dart';
import '../../../../../core/base_types/base_repository.dart';
import '../../../domain/domain.dart';
import '../../data.dart';

class PollDetailRepositoryImpl
    with BaseRepository
    implements PollDetailRepository {
  final PollDetailRemoteDataSource _remoteDataSource;

  PollDetailRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<PollDetail>> getPollDetail(int id) async {
    final result = await _remoteDataSource.getPollDetail(id);

    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<void>> submitPollAnswers({
    required int pollId,
    required PollAnswersRequest request,
  }) async {
    final requestModel = PollAnswersRequestModel(
      answers: request.answers.map((answer) => answer.toModel()).toList(),
    );
    return await _remoteDataSource.submitPollAnswers(
      pollId: pollId,
      request: requestModel,
    );
  }
}
