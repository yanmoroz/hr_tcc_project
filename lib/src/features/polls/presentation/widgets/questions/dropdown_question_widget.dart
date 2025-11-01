import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import 'question_widget_factory.dart';

class DropdownQuestionWidget extends StatefulWidget {
  final Question question;
  final AnswerChangedCallback onAnswerChanged;

  const DropdownQuestionWidget({super.key, required this.question, required this.onAnswerChanged});

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
      text: widget.question.hasCustomAnswer && _customTextController.text.isNotEmpty
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
    final answers = widget.question.answers.where((a) => a.isArchive != true).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(widget.question.title, style: Theme.of(context).textTheme.titleMedium)),
            if (widget.question.isRequired == true)
              Chip(
                label: const Text('Required'),
                labelStyle: const TextStyle(fontSize: 10),
                padding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
          ],
        ),
        if (widget.question.comment != null && widget.question.comment!.isNotEmpty) ...[
          const SizedBox(height: 4.0),
          Text(widget.question.comment!, style: Theme.of(context).textTheme.bodySmall),
        ],
        const SizedBox(height: 8.0),
        DropdownButtonFormField<Answer>(
          key: ValueKey(_selectedAnswer?.id),
          initialValue: _selectedAnswer,
          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Select an answer'),
          items: answers.map((answer) {
            return DropdownMenuItem<Answer>(value: answer, child: Text(answer.text ?? 'Option ${answer.id}'));
          }).toList(),
          onChanged: _onAnswerSelected,
        ),
        if (widget.question.hasCustomAnswer && _selectedAnswer != null) ...[
          const SizedBox(height: 8.0),
          TextField(
            controller: _customTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Custom answer (optional)',
              hintText: 'Enter your custom answer...',
            ),
            onChanged: _onCustomTextChanged,
          ),
        ],
      ],
    );
  }
}
