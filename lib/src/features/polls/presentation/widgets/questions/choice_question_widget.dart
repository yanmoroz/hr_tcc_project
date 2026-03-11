import 'package:flutter/material.dart';

import '../../../../../core/models/models.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/string_utils.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import 'question_callbacks.dart';

class ChoiceQuestionWidget extends StatefulWidget {
  final Question question;
  final AnswerChangedCallback onAnswerChanged;

  const ChoiceQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerChanged,
  });

  @override
  State<ChoiceQuestionWidget> createState() => _ChoiceQuestionWidgetState();
}

class _ChoiceQuestionWidgetState extends State<ChoiceQuestionWidget> {
  final Set<int> _selectedAnswerIds = {};
  final TextEditingController _customTextController = TextEditingController();

  @override
  void dispose() {
    _customTextController.dispose();
    super.dispose();
  }

  void _onSingleAnswerSelected(Answer answer) {
    setState(() {
      _selectedAnswerIds.clear();
      _selectedAnswerIds.add(answer.id);
      _updateAnswer();
    });
  }

  void _onCustomTextChanged(String text) {
    _updateAnswer();
  }

  void _updateAnswer() {
    if (_selectedAnswerIds.isEmpty) {
      widget.onAnswerChanged(widget.question, null);
      return;
    }

    // For multiple choice, we might need to send multiple answers
    // For now, let's send the first selected answer
    final firstAnswerId = _selectedAnswerIds.first;
    final answer = widget.question.answers.firstWhere(
      (a) => a.id == firstAnswerId,
    );

    String? customText;
    if (widget.question.hasCustomAnswer &&
        _customTextController.text.isNotEmpty) {
      customText = _customTextController.text;
    }

    final pollAnswer = PollAnswer.type1(
      type: 1,
      questionId: widget.question.id,
      answerId: answer.id,
      text: customText,
    );
    widget.onAnswerChanged(widget.question, pollAnswer);
  }

  @override
  Widget build(BuildContext context) {
    final answers = widget.question.answers
        .where((a) => a.isArchive != true)
        .toList();
    final isMultiple = widget.question.hasMultipliAnswer == true;

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
        if (isMultiple)
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: AppCheckBoxGroup<int>(
              value: _selectedAnswerIds,
              onChanged: (newSet) {
                setState(() {
                  _selectedAnswerIds
                    ..clear()
                    ..addAll(newSet);
                  _updateAnswer();
                });
              },
              items: answers.map((answer) {
                return CheckBoxItem<int>(
                  value: answer.id,
                  label: stripHtmlTags(answer.text ?? 'Option ${answer.id}'),
                );
              }).toList(),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: AppRadioButtonGroup<int>(
              value: _selectedAnswerIds.isEmpty
                  ? null
                  : _selectedAnswerIds.first,
              onChanged: (value) {
                if (value != null) {
                  final answer = answers.firstWhere((a) => a.id == value);
                  _onSingleAnswerSelected(answer);
                }
              },
              items: answers.map((answer) {
                return RadioButtonItem<int>(
                  value: answer.id,
                  label: stripHtmlTags(answer.text ?? 'Option ${answer.id}'),
                );
              }).toList(),
            ),
          ),
        // Custom answer text field - always shown after all options if hasCustomAnswer is true
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
