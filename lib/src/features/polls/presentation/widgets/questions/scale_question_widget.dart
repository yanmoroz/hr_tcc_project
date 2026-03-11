import 'package:flutter/material.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/string_utils.dart';
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
  final Map<int, int> _sliderValues = {};
  late final int _maxValue;
  late final int _minValue;

  @override
  void initState() {
    super.initState();
    _maxValue = widget.question.range ?? 10;
    _minValue = 1;
  }

  List<Answer> get _answers =>
      widget.question.answers.where((a) => a.isArchive != true).toList();

  void _onSliderChanged(Answer answer, int value) {
    setState(() {
      _sliderValues[answer.id] = value;
    });

    final allAnswered = _answers.every((a) => _sliderValues.containsKey(a.id));

    if (!allAnswered) {
      widget.onAnswerChanged(widget.question, null);
      return;
    }

    final pollAnswers = _answers
        .map(
          (a) => PollAnswer.type4(
            type: 4,
            questionId: widget.question.id,
            answerId: a.id,
            answerData: _sliderValues[a.id]!,
          ),
        )
        .toList();

    widget.onAnswerChanged(widget.question, pollAnswers);
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
        const SizedBox(height: 16.0),
        ..._answers.map(_buildAnswerSlider),
      ],
    );
  }

  Widget _buildAnswerSlider(Answer answer) {
    final value = _sliderValues[answer.id];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  stripHtmlTags(answer.text ?? ''),
                  style: AppTypography.textMedium1.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
              if (value != null)
                Text(
                  value.toString(),
                  style: AppTypography.textMedium1.copyWith(
                    color: AppColors.blue500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4.0),
          Slider(
            value: (value ?? _minValue).toDouble(),
            min: _minValue.toDouble(),
            max: _maxValue.toDouble(),
            divisions: _maxValue - _minValue,
            label: (value ?? _minValue).toString(),
            onChanged: (v) => _onSliderChanged(answer, v.toInt()),
            activeColor: AppColors.blue500,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.question.startText != null &&
                  widget.question.startText!.isNotEmpty)
                Text(
                  widget.question.startText!,
                  style: AppTypography.textRegular2.copyWith(
                    color: AppColors.grey700,
                  ),
                ),
              if (widget.question.endText != null &&
                  widget.question.endText!.isNotEmpty)
                Text(
                  widget.question.endText!,
                  style: AppTypography.textRegular2.copyWith(
                    color: AppColors.grey700,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
