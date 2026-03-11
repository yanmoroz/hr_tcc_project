import 'package:flutter/material.dart';

import '../../../../../core/utils/string_utils.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import 'question_callbacks.dart';

class MultiLineTextQuestionWidget extends StatefulWidget {
  final Question question;
  final AnswerChangedCallback onAnswerChanged;

  const MultiLineTextQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerChanged,
  });

  @override
  State<MultiLineTextQuestionWidget> createState() =>
      _MultiLineTextQuestionWidgetState();
}

class _MultiLineTextQuestionWidgetState
    extends State<MultiLineTextQuestionWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (text.isEmpty) {
      widget.onAnswerChanged(widget.question, null);
    } else {
      // For multiLineText, answerId is typically 0 or we need to get it from question
      final answerId = widget.question.answers.isNotEmpty
          ? widget.question.answers.first.id
          : 0;
      final answer = PollAnswer.type0(
        type: 0,
        questionId: widget.question.id,
        answerId: answerId,
        answerData: text,
      );
      widget.onAnswerChanged(widget.question, answer);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        AppTextFormField(
          controller: _controller,
          labelText: 'Ваш ответ',
          maxLines: 10,
          minLines: 5,
          onChanged: _onTextChanged,
        ),
      ],
    );
  }
}
