import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'poll_detail_event.freezed.dart';

@freezed
abstract class PollDetailEvent with _$PollDetailEvent {
  const factory PollDetailEvent.loadPollDetail() = LoadPollDetail;
  const factory PollDetailEvent.nextPage() = NextPage;
  const factory PollDetailEvent.previousPage() = PreviousPage;
  const factory PollDetailEvent.submitAnswers({
    required List<PollAnswer> answers,
  }) = SubmitAnswers;
  const factory PollDetailEvent.searchStaff({
    required StaffTarget target,
    String? search,
  }) = SearchStaff;
}
