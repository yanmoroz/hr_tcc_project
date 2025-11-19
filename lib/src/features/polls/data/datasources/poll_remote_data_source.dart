import '../../../../core/base_types/result.dart';
import '../../domain/domain.dart';
import '../models/responses/poll/poll_model.dart';
import '../models/responses/poll_detail/poll_answer_model.dart';
import '../models/responses/poll_detail/poll_detail_model.dart';
import '../models/responses/staff_item_model.dart';

abstract class PollRemoteDataSource {
  Future<Result<List<PollModel>>> getPolls({int? status, required int page});

  Future<Result<PollDetailModel>> getPollDetail(int id);

  Future<Result<void>> submitPollAnswers({
    required int pollId,
    required List<PollAnswerModel> answers,
  });

  Future<Result<List<StaffItemModel>>> getStaff({
    required StaffTarget target,
    String? search,
  });
}
