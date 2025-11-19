import 'package:freezed_annotation/freezed_annotation.dart';

import 'poll_answer.dart';

part 'poll_answers_request.freezed.dart';

@freezed
abstract class PollAnswersRequest with _$PollAnswersRequest {
  const factory PollAnswersRequest({required List<PollAnswer> answers}) =
      _PollAnswersRequest;
}
