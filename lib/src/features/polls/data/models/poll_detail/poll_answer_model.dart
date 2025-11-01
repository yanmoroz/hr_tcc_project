import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/entities/poll_detail/poll_answer.dart';
import 'attachment_file_model.dart';

part 'poll_answer_model.freezed.dart';

@Freezed(unionKey: 'type')
abstract class PollAnswerModel with _$PollAnswerModel {
  // Type 0: multiLineText
  const factory PollAnswerModel.type0({
    required int type,
    required int questionId,
    required int answerId,
    required String answerData,
  }) = PollAnswerModelType0;

  // Type 1: choice
  const factory PollAnswerModel.type1({
    required int type,
    required int questionId,
    required int answerId,
    String? text,
  }) = PollAnswerModelType1;

  // Type 2: tableLookup
  const factory PollAnswerModel.type2({
    required int type,
    required int questionId,
    required int answerId,
    required int answerData,
  }) = PollAnswerModelType2;

  // Type 3: dropdown
  const factory PollAnswerModel.type3({
    required int type,
    required int questionId,
    required int answerId,
    String? text,
  }) = PollAnswerModelType3;

  // Type 4: scale
  const factory PollAnswerModel.type4({
    required int type,
    required int questionId,
    required int answerId,
    required int answerData,
  }) = PollAnswerModelType4;

  // Type 5: attachment
  const factory PollAnswerModel.type5({
    required int type,
    required int questionId,
    required List<AttachmentFileModel> answerData,
  }) = PollAnswerModelType5;

  factory PollAnswerModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as int;
    switch (type) {
      case 0:
        return PollAnswerModel.type0(
          type: type,
          questionId: json['questionId'] as int,
          answerId: json['answerId'] as int,
          answerData: json['answerData'] as String,
        );
      case 1:
        return PollAnswerModel.type1(
          type: type,
          questionId: json['questionId'] as int,
          answerId: json['answerId'] as int,
          text: json['text'] as String?,
        );
      case 2:
        return PollAnswerModel.type2(
          type: type,
          questionId: json['questionId'] as int,
          answerId: json['answerId'] as int,
          answerData: json['answerData'] as int,
        );
      case 3:
        return PollAnswerModel.type3(
          type: type,
          questionId: json['questionId'] as int,
          answerId: json['answerId'] as int,
          text: json['text'] as String?,
        );
      case 4:
        return PollAnswerModel.type4(
          type: type,
          questionId: json['questionId'] as int,
          answerId: json['answerId'] as int,
          answerData: json['answerData'] as int,
        );
      case 5:
        return PollAnswerModel.type5(
          type: type,
          questionId: json['questionId'] as int,
          answerData: (json['answerData'] as List<dynamic>)
              .map((e) => AttachmentFileModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      default:
        throw ArgumentError('Unknown PollAnswer type: $type');
    }
  }
}

extension PollAnswerModelX on PollAnswerModel {
  Map<String, dynamic> toJson() {
    return map(
      type0: (model) => {
        'type': model.type,
        'questionId': model.questionId,
        'answerId': model.answerId,
        'answerData': model.answerData,
      },
      type1: (model) => {
        'type': model.type,
        'questionId': model.questionId,
        'answerId': model.answerId,
        if (model.text != null) 'text': model.text,
      },
      type2: (model) => {
        'type': model.type,
        'questionId': model.questionId,
        'answerId': model.answerId,
        'answerData': model.answerData,
      },
      type3: (model) => {
        'type': model.type,
        'questionId': model.questionId,
        'answerId': model.answerId,
        if (model.text != null) 'text': model.text,
      },
      type4: (model) => {
        'type': model.type,
        'questionId': model.questionId,
        'answerId': model.answerId,
        'answerData': model.answerData,
      },
      type5: (model) => {
        'type': model.type,
        'questionId': model.questionId,
        'answerData': model.answerData.map((file) => file.toJson()).toList(),
      },
    );
  }

  PollAnswer toDomain() {
    return map(
      type0: (model) => PollAnswer.type0(
        type: model.type,
        questionId: model.questionId,
        answerId: model.answerId,
        answerData: model.answerData,
      ),
      type1: (model) =>
          PollAnswer.type1(type: model.type, questionId: model.questionId, answerId: model.answerId, text: model.text),
      type2: (model) => PollAnswer.type2(
        type: model.type,
        questionId: model.questionId,
        answerId: model.answerId,
        answerData: model.answerData,
      ),
      type3: (model) =>
          PollAnswer.type3(type: model.type, questionId: model.questionId, answerId: model.answerId, text: model.text),
      type4: (model) => PollAnswer.type4(
        type: model.type,
        questionId: model.questionId,
        answerId: model.answerId,
        answerData: model.answerData,
      ),
      type5: (model) => PollAnswer.type5(
        type: model.type,
        questionId: model.questionId,
        answerData: model.answerData.map((file) => file.toDomain()).toList(),
      ),
    );
  }
}

extension PollAnswerX on PollAnswer {
  PollAnswerModel toModel() {
    return map(
      type0: (answer) => PollAnswerModel.type0(
        type: answer.type,
        questionId: answer.questionId,
        answerId: answer.answerId,
        answerData: answer.answerData,
      ),
      type1: (answer) => PollAnswerModel.type1(
        type: answer.type,
        questionId: answer.questionId,
        answerId: answer.answerId,
        text: answer.text,
      ),
      type2: (answer) => PollAnswerModel.type2(
        type: answer.type,
        questionId: answer.questionId,
        answerId: answer.answerId,
        answerData: answer.answerData,
      ),
      type3: (answer) => PollAnswerModel.type3(
        type: answer.type,
        questionId: answer.questionId,
        answerId: answer.answerId,
        text: answer.text,
      ),
      type4: (answer) => PollAnswerModel.type4(
        type: answer.type,
        questionId: answer.questionId,
        answerId: answer.answerId,
        answerData: answer.answerData,
      ),
      type5: (answer) => PollAnswerModel.type5(
        type: answer.type,
        questionId: answer.questionId,
        answerData: answer.answerData.map((file) => file.toModel()).toList(),
      ),
    );
  }
}
