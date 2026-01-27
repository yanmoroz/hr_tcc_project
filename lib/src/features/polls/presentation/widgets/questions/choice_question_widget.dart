import 'package:flutter/material.dart';

import '../../../../../core/utils/string_utils.dart';
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

  void _onAnswerToggled(Answer answer) {
    setState(() {
      if (_selectedAnswerIds.contains(answer.id)) {
        _selectedAnswerIds.remove(answer.id);
      } else {
        _selectedAnswerIds.add(answer.id);
      }
      _updateAnswer();
    });
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
        Row(
          children: [
            Expanded(
              child: Text(
                stripHtmlTags(widget.question.title),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (widget.question.isRequired == true)
              Chip(
                label: const Text('Required'),
                labelStyle: const TextStyle(fontSize: 10),
                padding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
          ],
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
          ...answers.map((answer) {
            return CheckboxListTile(
              title: Text(
                stripHtmlTags(answer.text ?? 'Option ${answer.id}'),
              ),
              value: _selectedAnswerIds.contains(answer.id),
              onChanged: (value) => _onAnswerToggled(answer),
              controlAffinity: ListTileControlAffinity.leading,
            );
          })
        else
          RadioGroup<int>(
            groupValue: _selectedAnswerIds.isEmpty
                ? null
                : _selectedAnswerIds.first,
            onChanged: (value) {
              if (value != null) {
                final answer = answers.firstWhere((a) => a.id == value);
                _onSingleAnswerSelected(answer);
              }
            },
            child: Column(
              children: answers.map((answer) {
                return RadioListTile<int>(
                  title: Text(
                    stripHtmlTags(answer.text ?? 'Option ${answer.id}'),
                  ),
                  value: answer.id,
                );
              }).toList(),
            ),
          ),
        // Custom answer text field - always shown after all options if hasCustomAnswer is true
        if (widget.question.hasCustomAnswer) ...[
          const SizedBox(height: 12.0),
          TextField(
            controller: _customTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ваш вариант ответа (необязательно)',
              hintText: 'Введите свой вариант...',
              isDense: true,
            ),
            onChanged: _onCustomTextChanged,
            maxLines: 2,
          ),
        ],
      ],
    );
  }
}
