import 'package:freezed_annotation/freezed_annotation.dart';

import 'attachment_file.dart';

part 'poll_answer.freezed.dart';

@Freezed(unionKey: 'type')
abstract class PollAnswer with _$PollAnswer {
  // Type 0: multiLineText
  const factory PollAnswer.type0({
    required int type,
    required int questionId,
    required int answerId,
    required String answerData,
  }) = PollAnswerType0;

  // Type 1: choice
  const factory PollAnswer.type1({
    required int type,
    required int questionId,
    required int answerId,
    String? text,
  }) = PollAnswerType1;

  // Type 2: tableLookup
  const factory PollAnswer.type2({
    required int type,
    required int questionId,
    required int answerId,
    required int answerData,
  }) = PollAnswerType2;

  // Type 3: dropdown
  const factory PollAnswer.type3({
    required int type,
    required int questionId,
    required int answerId,
    String? text,
  }) = PollAnswerType3;

  // Type 4: scale
  const factory PollAnswer.type4({
    required int type,
    required int questionId,
    required int answerId,
    required int answerData,
  }) = PollAnswerType4;

  // Type 5: attachment
  const factory PollAnswer.type5({
    required int type,
    required int questionId,
    required List<AttachmentFile> answerData,
  }) = PollAnswerType5;
}
