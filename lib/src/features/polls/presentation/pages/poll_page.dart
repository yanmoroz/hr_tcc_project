import 'package:flutter/material.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/domain.dart';
import '../blocs/poll_page/bloc.dart';
import '../widgets/questions/question_widget_factory.dart';

class PollPage extends StatefulWidget {
  final int pollId;

  const PollPage({super.key, required this.pollId});

  @override
  State<PollPage> createState() => _PollPageState();
}

class _PollPageState extends State<PollPage> {
  final Map<int, PollAnswer> _answers = {};
  final Set<int> _requiredQuestionIds = {};

  void _onAnswerChanged(Question question, Object? answer) {
    setState(() {
      if (answer == null) {
        _answers.remove(question.id);
      } else if (answer is PollAnswer) {
        _answers[question.id] = answer;
      }
    });
  }

  void _collectRequiredQuestions(PollDetail pollDetail) {
    _requiredQuestionIds.clear();
    for (final page in pollDetail.pages) {
      for (final question in [...page.questions, ...page.scaleQuestions]) {
        if (question.isRequired == true) {
          _requiredQuestionIds.add(question.id);
        }
      }
    }
  }

  bool _validateAnswers() {
    for (final questionId in _requiredQuestionIds) {
      if (!_answers.containsKey(questionId)) {
        return false;
      }
    }
    return true;
  }

  void _submitAnswers(BuildContext context, PollDetail pollDetail) {
    if (!_validateAnswers()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all required questions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final answersList = _answers.values.toList();
    context.read<PollDetailBloc>().add(
      PollDetailEvent.submitAnswers(answers: answersList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PollDetailBloc, PollDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: state.maybeWhen(
              loaded:
                  (
                    pollDetail,
                    isSearchingStaff,
                    staffItems,
                    staffSearchError,
                  ) => Text(pollDetail.title),
              submitted: (pollDetail) => Text(pollDetail.title),
              orElse: () => const Text('Poll'),
            ),
          ),
          body: state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded:
                (pollDetail, isSearchingStaff, staffItems, staffSearchError) {
                  _collectRequiredQuestions(pollDetail);
                  return _buildPollDetail(context, pollDetail);
                },
            submitting: (pollDetail) =>
                _buildPollDetail(context, pollDetail, isSubmitting: true),
            submitted: (pollDetail) =>
                _buildPollDetail(context, pollDetail, isSubmitted: true),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: $message',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PollDetailBloc>().add(
                        const PollDetailEvent.loadPollDetail(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPollDetail(
    BuildContext context,
    PollDetail pollDetail, {
    bool isSubmitting = false,
    bool isSubmitted = false,
  }) {
    if (isSubmitted) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Answers submitted successfully!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pollDetail.description != null &&
                    pollDetail.description!.isNotEmpty) ...[
                  Text(
                    pollDetail.description!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                ],
                ...pollDetail.pages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final page = entry.value;
                  return _buildPage(
                    context,
                    page,
                    index + 1,
                    pollDetail.pages.length,
                  );
                }),
                if (isSubmitting)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
        if (!isSubmitting && !isSubmitted)
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () => _submitAnswers(context, pollDetail),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Submit Answers'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPage(
    BuildContext context,
    Page page,
    int pageNumber,
    int totalPages,
  ) {
    final allQuestions = [...page.questions, ...page.scaleQuestions]
      ..sort((a, b) => a.position.compareTo(b.position));

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (page.title != null && page.title!.isNotEmpty)
              Text(
                'Page $pageNumber of $totalPages: ${page.title}',
                style: Theme.of(context).textTheme.titleLarge,
              )
            else
              Text(
                'Page $pageNumber of $totalPages',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            if (page.description != null && page.description!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Text(
                page.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (allQuestions.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Text('Questions', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8.0),
              ...allQuestions.map(
                (question) => _buildQuestion(context, question),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context, Question question) {
    final hasError =
        question.isRequired == true && !_answers.containsKey(question.id);
    final bloc = context.read<PollDetailBloc>();

    return BlocBuilder<PollDetailBloc, PollDetailState>(
      builder: (context, state) {
        final isSearchingStaff = state.maybeWhen(
          loaded:
              (pollDetail, isSearchingStaff, staffItems, staffSearchError) =>
                  isSearchingStaff,
          orElse: () => false,
        );

        final staffItems = state.maybeWhen(
          loaded:
              (pollDetail, isSearchingStaff, staffItems, staffSearchError) =>
                  staffItems,
          orElse: () => null,
        );

        final staffSearchError = state.maybeWhen(
          loaded:
              (pollDetail, isSearchingStaff, staffItems, staffSearchError) =>
                  staffSearchError,
          orElse: () => null,
        );

        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          color: hasError
              ? Theme.of(
                  context,
                ).colorScheme.errorContainer.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: buildQuestionWidget(
              question: question,
              onAnswerChanged: _onAnswerChanged,
              onFileUpload:
                  ({required file, required systemType, required onProgress}) {
                    return bloc.uploadFileUsecase(
                      file: file,
                      systemType: systemType,
                      onProgress: onProgress,
                    );
                  },
              onStaffSearch: (target, search) {
                bloc.add(
                  PollDetailEvent.searchStaff(target: target, search: search),
                );
              },
              isSearchingStaff: isSearchingStaff,
              staffItems: staffItems,
              staffSearchError: staffSearchError,
            ),
          ),
        );
      },
    );
  }
}
