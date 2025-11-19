import 'package:flutter/material.dart';

import '../../../domain/domain.dart';
import 'question_callbacks.dart';

class MultiLineTextQuestionWidget extends StatefulWidget {
  final Question question;
  final AnswerChangedCallback onAnswerChanged;

  const MultiLineTextQuestionWidget({super.key, required this.question, required this.onAnswerChanged});

  @override
  State<MultiLineTextQuestionWidget> createState() => _MultiLineTextQuestionWidgetState();
}

class _MultiLineTextQuestionWidgetState extends State<MultiLineTextQuestionWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _hasError = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    setState(() {
      _hasError = false;
    });

    if (text.isEmpty) {
      widget.onAnswerChanged(widget.question, null);
    } else {
      // For multiLineText, answerId is typically 0 or we need to get it from question
      final answerId = widget.question.answers.isNotEmpty ? widget.question.answers.first.id : 0;
      final answer = PollAnswer.type0(type: 0, questionId: widget.question.id, answerId: answerId, answerData: text);
      widget.onAnswerChanged(widget.question, answer);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        TextField(
          controller: _controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Enter your answer here...',
            border: const OutlineInputBorder(),
            errorText: _hasError ? 'This field is required' : null,
          ),
          onChanged: _onTextChanged,
        ),
      ],
    );
  }
}
