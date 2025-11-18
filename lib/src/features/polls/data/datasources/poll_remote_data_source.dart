import '../../../../core/base_types/result.dart';
import '../../domain/entities/shared_types/staff_target.dart';
import '../models/poll/poll_model.dart';
import '../models/poll/staff_item_model.dart';
import '../models/poll_detail/poll_answers_request_model.dart';
import '../models/poll_detail/poll_detail_model.dart';

abstract class PollRemoteDataSource {
  Future<Result<List<PollModel>>> getPolls({int? status, required int page});

  Future<Result<PollDetailModel>> getPollDetail(int id);

  Future<Result<void>> submitPollAnswers({
    required int pollId,
    required PollAnswersRequestModel request,
  });

  Future<Result<List<StaffItemModel>>> getStaff({
    required StaffTarget target,
    String? search,
  });
}
