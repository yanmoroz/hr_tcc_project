import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer.freezed.dart';

@freezed
abstract class Answer with _$Answer {
  const factory Answer({
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
  }) = _Answer;
}
