import 'package:flutter/material.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/domain.dart';
import '../blocs/poll_page/bloc.dart';
import '../widgets/poll_success_dialog.dart';
import '../widgets/questions/question_widget_factory.dart';

class PollPage extends StatefulWidget {
  const PollPage({super.key});

  @override
  State<PollPage> createState() => _PollPageState();
}

class _PollPageState extends State<PollPage> {
  final Map<int, PollAnswer> _answers = {};
  final Set<int> _requiredQuestionIds = {};
  bool _submittedSuccessfully = false;

  void _onAnswerChanged(Question question, Object? answer) {
    setState(() {
      if (answer == null) {
        _answers.remove(question.id);
      } else if (answer is PollAnswer) {
        _answers[question.id] = answer;
      }
    });
  }

  void _collectRequiredQuestionsForCurrentPage(Page page) {
    _requiredQuestionIds.clear();
    for (final question in [...page.questions, ...page.scaleQuestions]) {
      if (question.isRequired == true) {
        _requiredQuestionIds.add(question.id);
      }
    }
  }

  bool _validateCurrentPage() {
    for (final questionId in _requiredQuestionIds) {
      if (!_answers.containsKey(questionId)) {
        return false;
      }
    }
    return true;
  }

  void _handlePrimaryButton(
    BuildContext context,
    PollDetail pollDetail,
    bool isLastPage,
  ) {
    final currentPage =
        pollDetail.pages[context.read<PollDetailBloc>().state.currentPageIndex];
    _collectRequiredQuestionsForCurrentPage(currentPage);

    if (!_validateCurrentPage()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, ответьте на все обязательные вопросы'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (isLastPage) {
      // Mark that we're attempting submission
      setState(() {
        _submittedSuccessfully = true;
      });

      // Submit all answers
      final answersList = _answers.values.toList();
      context.read<PollDetailBloc>().add(
        PollDetailEvent.submitAnswers(answers: answersList),
      );
    } else {
      // Move to next page
      context.read<PollDetailBloc>().add(const PollDetailEvent.nextPage());
    }
  }

  String _formatPollDate(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final pollDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final timeFormat = DateFormat('HH:mm').format(dateTime);

    if (pollDate == today) {
      return 'Сегодня в $timeFormat';
    } else if (pollDate == yesterday) {
      return 'Вчера в $timeFormat';
    } else {
      final dateFormat = DateFormat('dd.MM.yyyy').format(dateTime);
      return '$dateFormat в $timeFormat';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PollDetailBloc, PollDetailState>(
      listener: (context, state) {
        // Handle successful submission
        if (state.status == LoadingStatus.success &&
            !state.isSubmitting &&
            state.pollDetail != null &&
            _submittedSuccessfully) {
          // Show success modal dialog
          PollSuccessDialog.show(context);
        }
      },
      builder: (context, state) {
        final isFirstPage = state.currentPageIndex == 0;

        return Scaffold(
          appBar: AppBar(
            leading: isFirstPage
                ? null
                : IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.read<PollDetailBloc>().add(
                      const PollDetailEvent.previousPage(),
                    ),
                  ),
            automaticallyImplyLeading: false,
            title: Text(_getAppBarTitle(state)),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () async {
                  final shouldExit = await showConfirmationDialog(
                    context,
                    title: 'Прекратить прохождение опроса?',
                    content: '',
                    confirmText: 'Прекратить',
                    cancelText: 'Отмена',
                    isDestructive: true,
                  );
                  if (shouldExit == true && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
          body: _buildBody(context, state),
          backgroundColor: AppColors.white,
        );
      },
    );
  }

  String _getAppBarTitle(PollDetailState state) {
    if (state.pollDetail != null) {
      return 'Шаг ${state.currentPageIndex + 1}/${state.pollDetail!.pages.length}';
    }
    return 'Шаг 1/1';
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
              'Ошибка: ${state.errorMessage ?? 'Неизвестная ошибка'}',
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
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    // Success state
    final pollDetail = state.pollDetail;

    if (pollDetail == null) {
      return const Center(child: Text('Нет данных'));
    }

    final currentPage = pollDetail.pages[state.currentPageIndex];

    return _buildSinglePageView(
      context,
      pollDetail,
      currentPage,
      state.currentPageIndex,
      isSubmitting: state.isSubmitting,
    );
  }

  Widget _buildSinglePageView(
    BuildContext context,
    PollDetail pollDetail,
    Page page,
    int pageIndex, {
    bool isSubmitting = false,
  }) {
    final allQuestions = [...page.questions, ...page.scaleQuestions]
      ..sort((a, b) => a.position.compareTo(b.position));

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content with padding
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status chip and creation date
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: pollDetail.canAnswer
                                  ? AppColors.orange100
                                  : AppColors.grey500,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              pollDetail.canAnswer ? 'Не пройден' : 'Пройден',
                              style: AppTypography.captionMedium2.copyWith(
                                color: pollDetail.canAnswer
                                    ? AppColors.black
                                    : AppColors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatPollDate(pollDetail.createdAt),
                            style: AppTypography.captionMedium2.copyWith(
                              color: AppColors.grey700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Cover image (if available)
                      if (context.read<PollDetailBloc>().state.coverImage !=
                          null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            context.read<PollDetailBloc>().state.coverImage!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Poll title
                      Text(
                        page.title ?? pollDetail.title,
                        style: AppTypography.titleSemibold3.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Render questions
                      ...allQuestions.map(
                        (question) => _buildQuestion(context, question),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Navigation buttons
        _buildNavigationButtons(context, pollDetail, pageIndex, isSubmitting),
      ],
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    PollDetail pollDetail,
    int currentPageIndex,
    bool isSubmitting,
  ) {
    final isFirstPage = currentPageIndex == 0;
    final isLastPage = currentPageIndex == pollDetail.pages.length - 1;

    return Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // "Go Back" button (only show if not first page)
            if (!isFirstPage) ...[
              PrimaryButton(
                label: 'Вернуться назад',
                size: PrimaryButtonSize.large,
                style: PrimatyButtonStyle.white,
                enabled: !isSubmitting,
                onPressed: () => context.read<PollDetailBloc>().add(
                  const PollDetailEvent.previousPage(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // "Continue" or "Submit" button
            PrimaryButton(
              label: isLastPage ? 'Завершить опрос' : 'Продолжить',
              size: PrimaryButtonSize.large,
              style: PrimatyButtonStyle.colored,
              enabled: !isSubmitting,
              isLoading: isSubmitting,
              onPressed: () =>
                  _handlePrimaryButton(context, pollDetail, isLastPage),
            ),
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
              onFileUpload: bloc.uploadFile,
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
