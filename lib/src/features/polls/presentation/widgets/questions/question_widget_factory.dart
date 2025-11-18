import 'package:flutter/material.dart';

import '../../../domain/domain.dart';
import 'multi_line_text_question_widget.dart';
import 'choice_question_widget.dart';
import 'table_lookup_question_widget.dart';
import 'dropdown_question_widget.dart';
import 'scale_question_widget.dart';
import 'attachment_question_widget.dart';

typedef AnswerChangedCallback = void Function(Question question, Object? answer);

Widget buildQuestionWidget({
  required Question question,
  required AnswerChangedCallback onAnswerChanged,
  FileUploadCallback? onFileUpload,
}) {
  switch (question.type) {
    case QuestionType.multiLineText:
      return MultiLineTextQuestionWidget(question: question, onAnswerChanged: onAnswerChanged);
    case QuestionType.choice:
      return ChoiceQuestionWidget(question: question, onAnswerChanged: onAnswerChanged);
    case QuestionType.tableLookup:
      return TableLookupQuestionWidget(question: question, onAnswerChanged: onAnswerChanged);
    case QuestionType.dropdown:
      return DropdownQuestionWidget(question: question, onAnswerChanged: onAnswerChanged);
    case QuestionType.scale:
      return ScaleQuestionWidget(question: question, onAnswerChanged: onAnswerChanged);
    case QuestionType.attachment:
      assert(onFileUpload != null, 'onFileUpload callback is required for attachment questions');
      return AttachmentQuestionWidget(
        question: question,
        onAnswerChanged: onAnswerChanged,
        onFileUpload: onFileUpload!,
      );
  }
}
