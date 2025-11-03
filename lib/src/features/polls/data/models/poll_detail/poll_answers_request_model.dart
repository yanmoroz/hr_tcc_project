import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';
import 'poll_answer_model.dart';

part 'poll_answers_request_model.freezed.dart';
part 'poll_answers_request_model.g.dart';

@freezed
abstract class PollAnswersRequestModel with _$PollAnswersRequestModel {
  const factory PollAnswersRequestModel({
    @JsonKey(fromJson: _answersFromJson, toJson: _answersToJson) required List<PollAnswerModel> answers,
  }) = _PollAnswersRequestModel;

  factory PollAnswersRequestModel.fromJson(Map<String, dynamic> json) => _$PollAnswersRequestModelFromJson(json);
}

List<PollAnswerModel> _answersFromJson(List<dynamic> json) {
  return json.map((e) => PollAnswerModel.fromJson(e as Map<String, dynamic>)).toList();
}

List<Map<String, dynamic>> _answersToJson(List<PollAnswerModel> answers) {
  return answers.map((answer) => answer.toJson()).toList();
}

extension PollAnswersRequestModelX on PollAnswersRequestModel {
  PollAnswersRequest toDomain() => PollAnswersRequest(answers: answers.map((answer) => answer.toDomain()).toList());
}
