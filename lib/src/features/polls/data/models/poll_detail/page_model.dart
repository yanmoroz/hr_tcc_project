import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';
import 'question_model.dart';

part 'page_model.freezed.dart';
part 'page_model.g.dart';

@freezed
abstract class PageModel with _$PageModel {
  const factory PageModel({
    required int id,
    String? title,
    String? description,
    bool? isArchive,
    required List<QuestionModel> questions,
    required List<QuestionModel> scaleQuestions,
    required bool isRandomQuestionPosition,
    required bool isRandomAnswerPosition,
    required int position,
  }) = _PageModel;

  factory PageModel.fromJson(Map<String, dynamic> json) => _$PageModelFromJson(json);
}

extension PageModelX on PageModel {
  Page toDomain() => Page(
    id: id,
    title: title,
    description: description,
    isArchive: isArchive,
    questions: questions.map((question) => question.toDomain()).toList(),
    scaleQuestions: scaleQuestions.map((question) => question.toDomain()).toList(),
    isRandomQuestionPosition: isRandomQuestionPosition,
    isRandomAnswerPosition: isRandomAnswerPosition,
    position: position,
  );
}
