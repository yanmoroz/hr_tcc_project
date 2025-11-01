import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import 'question_widget_factory.dart';

class ChoiceQuestionWidget extends StatefulWidget {
  final Question question;
  final AnswerChangedCallback onAnswerChanged;

  const ChoiceQuestionWidget({super.key, required this.question, required this.onAnswerChanged});

  @override
  State<ChoiceQuestionWidget> createState() => _ChoiceQuestionWidgetState();
}

class _ChoiceQuestionWidgetState extends State<ChoiceQuestionWidget> {
  final Set<int> _selectedAnswerIds = {};
  final Map<int, TextEditingController> _customTextControllers = {};
  final TextEditingController _singleCustomTextController = TextEditingController();

  @override
  void dispose() {
    for (var controller in _customTextControllers.values) {
      controller.dispose();
    }
    _singleCustomTextController.dispose();
    super.dispose();
  }

  void _onAnswerToggled(Answer answer) {
    setState(() {
      if (_selectedAnswerIds.contains(answer.id)) {
        _selectedAnswerIds.remove(answer.id);
        _customTextControllers[answer.id]?.dispose();
        _customTextControllers.remove(answer.id);
      } else {
        _selectedAnswerIds.add(answer.id);
        if (widget.question.hasCustomAnswer) {
          _customTextControllers[answer.id] = TextEditingController();
        }
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

  void _onCustomTextChanged(int answerId, String text) {
    _updateAnswer();
  }

  void _onSingleCustomTextChanged(String text) {
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
    final answer = widget.question.answers.firstWhere((a) => a.id == firstAnswerId);

    String? customText;
    if (widget.question.hasCustomAnswer) {
      if (widget.question.hasMultipliAnswer == true) {
        customText = _customTextControllers[firstAnswerId]?.text;
      } else {
        customText = _singleCustomTextController.text.isNotEmpty ? _singleCustomTextController.text : null;
      }
    }

    final pollAnswer = PollAnswer.type1(
      type: 1,
      questionId: widget.question.id,
      answerId: answer.id,
      text: customText?.isNotEmpty == true ? customText : null,
    );
    widget.onAnswerChanged(widget.question, pollAnswer);
  }

  @override
  Widget build(BuildContext context) {
    final answers = widget.question.answers.where((a) => a.isArchive != true).toList();
    final isMultiple = widget.question.hasMultipliAnswer == true;

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
        if (isMultiple)
          ...answers.map((answer) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  title: Text(answer.text ?? 'Option ${answer.id}'),
                  value: _selectedAnswerIds.contains(answer.id),
                  onChanged: (value) => _onAnswerToggled(answer),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                if (widget.question.hasCustomAnswer && _selectedAnswerIds.contains(answer.id)) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 16.0, bottom: 8.0),
                    child: TextField(
                      controller: _customTextControllers[answer.id],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Custom answer (optional)',
                        hintText: 'Enter your custom answer...',
                        isDense: true,
                      ),
                      onChanged: (text) => _onCustomTextChanged(answer.id, text),
                    ),
                  ),
                ],
              ],
            );
          })
        else
          RadioGroup<int>(
            groupValue: _selectedAnswerIds.isEmpty ? null : _selectedAnswerIds.first,
            onChanged: (value) {
              if (value != null) {
                final answer = answers.firstWhere((a) => a.id == value);
                _onSingleAnswerSelected(answer);
              }
            },
            child: Column(
              children: [
                ...answers.map((answer) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile<int>(title: Text(answer.text ?? 'Option ${answer.id}'), value: answer.id),
                      if (widget.question.hasCustomAnswer && _selectedAnswerIds.contains(answer.id)) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0, right: 16.0, bottom: 8.0),
                          child: TextField(
                            controller: _singleCustomTextController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Custom answer (optional)',
                              hintText: 'Enter your custom answer...',
                              isDense: true,
                            ),
                            onChanged: _onSingleCustomTextChanged,
                          ),
                        ),
                      ],
                    ],
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}
