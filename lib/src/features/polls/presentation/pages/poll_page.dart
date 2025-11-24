import 'package:flutter/material.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../domain/domain.dart';
import '../blocs/poll_page/bloc.dart';
import '../widgets/questions/question_widget_factory.dart';

class PollPage extends StatefulWidget {
  const PollPage({super.key});

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
        // Get poll title for app bar
        final title = _getAppBarTitle(state);

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: _buildBody(context, state),
        );
      },
    );
  }

  String _getAppBarTitle(PollDetailState state) {
    // if (state.status == LoadingStatus.success && state.pollDetail != null) {
    //   return state.pollDetail!.title;
    // }
    // return 'Poll';
    return 'Шаг X/Y';
  }

  Widget _buildBody(BuildContext context, PollDetailState state) {
    if (state.status == LoadingStatus.loading ||
        state.status == LoadingStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == LoadingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.errorMessage ?? 'Unknown error'}',
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
      );
    }

    // Success state
    final pollDetail = state.pollDetail;

    if (pollDetail == null) {
      return const Center(child: Text('No data available'));
    }

    _collectRequiredQuestions(pollDetail);

    return _buildPollDetail(
      context,
      pollDetail,
      isSubmitting: state.isSubmitting,
    );
  }

  Widget _buildPollDetail(
    BuildContext context,
    PollDetail pollDetail, {
    bool isSubmitting = false,
  }) {
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
        if (!isSubmitting)
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
        final isSearchingStaff = state.isSearchingStaff;
        final staffItems = state.staffItems;
        final staffSearchError = state.staffSearchError;

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
