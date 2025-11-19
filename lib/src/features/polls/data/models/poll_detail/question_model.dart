import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';
import 'answer_model.dart';
import 'page_model.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
abstract class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required int id,
    required String title,
    String? picture,
    String? comment,
    @JsonKey(name: 'isReqered') bool? isRequired,
    required bool hasCustomAnswer,
    bool? hasMultipliAnswer,
    bool? isArchive,
    int? categoryId,
    @JsonKey(fromJson: questionTypeFromJson) required QuestionType type,
    required int position,
    required int lookupType,
    required bool isNoAnswer,
    String? startText,
    String? middleText,
    String? endText,
    int? range,
    PageModel? page,
    required List<AnswerModel> answers,
    bool? isRandomQuestionPosition,
    bool? isRandomAnswerPosition,
    String? image,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

extension QuestionModelX on QuestionModel {
  Question toDomain() => Question(
    id: id,
    title: title,
    picture: picture,
    comment: comment,
    isRequired: isRequired,
    hasCustomAnswer: hasCustomAnswer,
    hasMultipliAnswer: hasMultipliAnswer,
    isArchive: isArchive,
    categoryId: categoryId,
    type: type,
    position: position,
    lookupType: lookupType,
    isNoAnswer: isNoAnswer,
    startText: startText,
    middleText: middleText,
    endText: endText,
    range: range,
    page: page?.toDomain(),
    answers: answers.map((answer) => answer.toDomain()).toList(),
    isRandomQuestionPosition: isRandomQuestionPosition,
    isRandomAnswerPosition: isRandomAnswerPosition,
    image: image,
  );
}
