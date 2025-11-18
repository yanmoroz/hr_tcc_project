import '../../../../core/base_types/result.dart';
import '../../../../core/base_types/base_repository.dart';
import '../../domain/domain.dart';
import '../data.dart';
import '../datasources/poll_remote_data_source.dart';

class PollRepositoryImpl with BaseRepository implements PollRepository {
  final PollRemoteDataSource _remoteDataSource;

  PollRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Poll>>> getPolls({int? status, required int page}) async {
    final result = await _remoteDataSource.getPolls(status: status, page: page);

    return mapResultList(result, (model) => model.toDomain());
  }

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

  @override
  Future<Result<List<StaffItem>>> getStaff({
    required StaffTarget target,
    String? search,
  }) async {
    final result = await _remoteDataSource.getStaff(
      target: target,
      search: search,
    );

    return mapResultList(result, (model) => model.toDomain());
  }
}
