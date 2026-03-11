import 'package:flutter/material.dart';

import '../../../../../core/models/models.dart';
import '../../../../../core/utils/string_utils.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import 'question_callbacks.dart';

class DropdownQuestionWidget extends StatefulWidget {
  final Question question;
  final AnswerChangedCallback onAnswerChanged;

  const DropdownQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerChanged,
  });

  @override
  State<DropdownQuestionWidget> createState() => _DropdownQuestionWidgetState();
}

class _DropdownQuestionWidgetState extends State<DropdownQuestionWidget> {
  Answer? _selectedAnswer;
  final TextEditingController _customTextController = TextEditingController();

  @override
  void dispose() {
    _customTextController.dispose();
    super.dispose();
  }

  void _onAnswerSelected(Answer? answer) {
    setState(() {
      _selectedAnswer = answer;
    });

    if (answer == null) {
      widget.onAnswerChanged(widget.question, null);
      return;
    }

    final pollAnswer = PollAnswer.type3(
      type: 3,
      questionId: widget.question.id,
      answerId: answer.id,
      text:
          widget.question.hasCustomAnswer &&
              _customTextController.text.isNotEmpty
          ? _customTextController.text
          : null,
    );
    widget.onAnswerChanged(widget.question, pollAnswer);
  }

  void _onCustomTextChanged(String text) {
    if (_selectedAnswer != null) {
      final pollAnswer = PollAnswer.type3(
        type: 3,
        questionId: widget.question.id,
        answerId: _selectedAnswer!.id,
        text: text.isNotEmpty ? text : null,
      );
      widget.onAnswerChanged(widget.question, pollAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final answers = widget.question.answers
        .where((a) => a.isArchive != true)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleMedium,
            children: [
              TextSpan(text: stripHtmlTags(widget.question.title)),
              if (widget.question.isRequired == true)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        if (widget.question.comment != null &&
            widget.question.comment!.isNotEmpty) ...[
          const SizedBox(height: 4.0),
          Text(
            widget.question.comment!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 8.0),
        AppDropdownFormField<Answer>(
          value: _selectedAnswer,
          onChanged: _onAnswerSelected,
          labelText: 'Выберите вариант',
          modalTitle: 'Выберите вариант',
          items: answers.map((answer) {
            return RadioButtonItem<Answer>(
              value: answer,
              label: stripHtmlTags(answer.text ?? 'Option ${answer.id}'),
            );
          }).toList(),
        ),
        // Custom answer text field - always shown after dropdown if hasCustomAnswer is true
        if (widget.question.hasCustomAnswer) ...[
          const SizedBox(height: 12.0),
          AppTextFormField(
            controller: _customTextController,
            labelText: 'Ваш вариант ответа (необязательно)',
            onChanged: _onCustomTextChanged,
            maxLines: 4,
          ),
        ],
      ],
    );
  }
}
