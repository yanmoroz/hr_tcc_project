import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';
import 'poll_answer_model.dart';

part 'poll_answers_request_model.freezed.dart';
part 'poll_answers_request_model.g.dart';

@freezed
abstract class PollAnswersRequestModel with _$PollAnswersRequestModel {
  const factory PollAnswersRequestModel({required List<PollAnswerModel> answers}) = _PollAnswersRequestModel;

  factory PollAnswersRequestModel.fromJson(Map<String, dynamic> json) => _$PollAnswersRequestModelFromJson(json);
}

extension PollAnswersRequestModelX on PollAnswersRequestModel {
  PollAnswersRequest toDomain() => PollAnswersRequest(answers: answers.map((answer) => answer.toDomain()).toList());
}
