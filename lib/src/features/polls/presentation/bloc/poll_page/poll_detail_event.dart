import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'poll_detail_event.freezed.dart';

@freezed
abstract class PollDetailEvent with _$PollDetailEvent {
  const factory PollDetailEvent.loadPollDetail(int pollId) = LoadPollDetail;
  const factory PollDetailEvent.submitAnswers({required int pollId, required PollAnswersRequest request}) =
      SubmitAnswers;
}
