import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/domain.dart';

part 'answer_model.freezed.dart';
part 'answer_model.g.dart';

@freezed
abstract class AnswerModel with _$AnswerModel {
  const factory AnswerModel({
    required int id,
    required int questionId,
    required int weight,
    String? text,
    String? picture,
    int? position,
    bool? isArchive,
    bool? isCorrect,
    int? linkedQuestionId,
    int? linkedPageId,
    String? image,
  }) = _AnswerModel;

  factory AnswerModel.fromJson(Map<String, dynamic> json) =>
      _$AnswerModelFromJson(json);
}

extension AnswerModelX on AnswerModel {
  Answer toDomain() => Answer(
    id: id,
    questionId: questionId,
    weight: weight,
    text: text,
    picture: picture,
    position: position,
    isArchive: isArchive,
    isCorrect: isCorrect,
    linkedQuestionId: linkedQuestionId,
    linkedPageId: linkedPageId,
    image: image,
  );
}
