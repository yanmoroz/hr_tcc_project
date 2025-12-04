import 'package:flutter/material.dart';

import '../../../domain/domain.dart';
import 'question_callbacks.dart';

class ScaleQuestionWidget extends StatefulWidget {
  final Question question;
  final AnswerChangedCallback onAnswerChanged;

  const ScaleQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerChanged,
  });

  @override
  State<ScaleQuestionWidget> createState() => _ScaleQuestionWidgetState();
}

class _ScaleQuestionWidgetState extends State<ScaleQuestionWidget> {
  int? _selectedValue;
  late final int _maxValue;
  late final int _minValue;

  @override
  void initState() {
    super.initState();
    _maxValue = widget.question.range ?? 10;
    _minValue = 1;
  }

  void _onValueChanged(int value) {
    setState(() {
      _selectedValue = value;
    });

    // For scale questions, answerId might be the question's ID or we need a default
    final answerId = widget.question.answers.isNotEmpty
        ? widget.question.answers.first.id
        : widget.question.id;
    final pollAnswer = PollAnswer.type4(
      type: 4,
      questionId: widget.question.id,
      answerId: answerId,
      answerData: value,
    );
    widget.onAnswerChanged(widget.question, pollAnswer);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.question.title,
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
        const SizedBox(height: 16.0),
        Row(
          children: [
            if (widget.question.startText != null &&
                widget.question.startText!.isNotEmpty)
              Expanded(
                child: Text(
                  widget.question.startText!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.left,
                ),
              ),
            if (widget.question.middleText != null &&
                widget.question.middleText!.isNotEmpty)
              Expanded(
                child: Text(
                  widget.question.middleText!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            if (widget.question.endText != null &&
                widget.question.endText!.isNotEmpty)
              Expanded(
                child: Text(
                  widget.question.endText!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.right,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8.0),
        Slider(
          value: _selectedValue?.toDouble() ?? _minValue.toDouble(),
          min: _minValue.toDouble(),
          max: _maxValue.toDouble(),
          divisions: _maxValue - _minValue,
          label: _selectedValue?.toString() ?? _minValue.toString(),
          onChanged: (value) => _onValueChanged(value.toInt()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _minValue.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (_selectedValue != null)
              Text(
                'Selected: $_selectedValue',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            Text(
              _maxValue.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
