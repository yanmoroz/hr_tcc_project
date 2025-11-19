import 'package:flutter/material.dart';

import '../../../domain/domain.dart';
import 'multi_line_text_question_widget.dart';
import 'choice_question_widget.dart';
import 'table_lookup_question_widget.dart';
import 'dropdown_question_widget.dart';
import 'scale_question_widget.dart';
import 'attachment_question_widget.dart';
import 'question_callbacks.dart';

Widget buildQuestionWidget({
  required Question question,
  required AnswerChangedCallback onAnswerChanged,
  FileUploadCallback? onFileUpload,
  StaffSearchCallback? onStaffSearch,
  bool isSearchingStaff = false,
  List<StaffItem>? staffItems,
  String? staffSearchError,
}) {
  switch (question.type) {
    case QuestionType.multiLineText:
      return MultiLineTextQuestionWidget(question: question, onAnswerChanged: onAnswerChanged);
    case QuestionType.choice:
      return ChoiceQuestionWidget(question: question, onAnswerChanged: onAnswerChanged);
    case QuestionType.tableLookup:
      assert(onStaffSearch != null, 'onStaffSearch callback is required for tableLookup questions');
      return TableLookupQuestionWidget(
        question: question,
        onAnswerChanged: onAnswerChanged,
        onStaffSearch: onStaffSearch!,
        isSearchingStaff: isSearchingStaff,
        staffItems: staffItems,
        staffSearchError: staffSearchError,
      );
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
