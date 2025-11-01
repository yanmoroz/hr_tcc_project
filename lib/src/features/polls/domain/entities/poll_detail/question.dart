import 'package:freezed_annotation/freezed_annotation.dart';

import 'answer.dart';
import 'page.dart';

part 'question.freezed.dart';

@freezed
abstract class Question with _$Question {
  const factory Question({
    required int id,
    required String title,
    String? picture,
    String? comment,
    bool? isReqered,
    required bool hasCustomAnswer,
    bool? hasMultipliAnswer,
    bool? isArchive,
    int? categoryId,
    required int type,
    required int position,
    required int lookupType,
    required bool isNoAnswer,
    String? startText,
    String? middleText,
    String? endText,
    int? range,
    Page? page,
    required List<Answer> answers,
    bool? isRandomQuestionPosition,
    bool? isRandomAnswerPosition,
    String? image,
  }) = _Question;
}
