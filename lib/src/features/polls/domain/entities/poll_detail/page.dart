import 'package:freezed_annotation/freezed_annotation.dart';

import 'question.dart';

part 'page.freezed.dart';

@freezed
abstract class Page with _$Page {
  const factory Page({
    required int id,
    String? title,
    String? description,
    bool? isArchive,
    required List<Question> questions,
    required List<Question> scaleQuestions,
    required bool isRandomQuestionPosition,
    required bool isRandomAnswerPosition,
    required int position,
  }) = _Page;
}
