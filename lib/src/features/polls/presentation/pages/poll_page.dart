import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../domain/entities/entities.dart';
import '../../domain/entities/poll_detail/page.dart' as poll_page;
import '../bloc/poll_page/poll_detail_bloc.dart';
import '../bloc/poll_page/poll_detail_event.dart';
import '../bloc/poll_page/poll_detail_state.dart';

class PollPage extends StatelessWidget {
  final int pollId;

  const PollPage({super.key, required this.pollId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PollDetailBloc>()..add(PollDetailEvent.loadPollDetail(pollId)),
      child: BlocBuilder<PollDetailBloc, PollDetailState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: state.maybeWhen(
                loaded: (pollDetail) => Text(pollDetail.title),
                submitted: (pollDetail) => Text(pollDetail.title),
                orElse: () => const Text('Poll'),
              ),
            ),
            body: state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (pollDetail) => _buildPollDetail(context, pollDetail),
              submitting: (pollDetail) => _buildPollDetail(context, pollDetail, isSubmitting: true),
              submitted: (pollDetail) => _buildPollDetail(context, pollDetail, isSubmitted: true),
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $message', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PollDetailBloc>().add(PollDetailEvent.loadPollDetail(pollId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
            Text('Answers submitted successfully!', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pollDetail.description != null && pollDetail.description!.isNotEmpty) ...[
            Text(pollDetail.description!, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
          ],
          ...pollDetail.pages.asMap().entries.map((entry) {
            final index = entry.key;
            final page = entry.value;
            return _buildPage(context, page, index + 1, pollDetail.pages.length);
          }),
          if (isSubmitting)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, poll_page.Page page, int pageNumber, int totalPages) {
    final allQuestions = [...page.questions, ...page.scaleQuestions]..sort((a, b) => a.position.compareTo(b.position));

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (page.title != null && page.title!.isNotEmpty)
              Text('Page $pageNumber of $totalPages: ${page.title}', style: Theme.of(context).textTheme.titleLarge)
            else
              Text('Page $pageNumber of $totalPages', style: Theme.of(context).textTheme.titleLarge),
            if (page.description != null && page.description!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Text(page.description!, style: Theme.of(context).textTheme.bodyMedium),
            ],
            if (allQuestions.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Text('Questions', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8.0),
              ...allQuestions.map((question) => _buildQuestion(context, question)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context, Question question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(question.title, style: Theme.of(context).textTheme.titleMedium)),
                if (question.isRequired == true)
                  Chip(
                    label: const Text('Required'),
                    labelStyle: const TextStyle(fontSize: 10),
                    padding: EdgeInsets.zero,
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  ),
              ],
            ),
            if (question.comment != null && question.comment!.isNotEmpty) ...[
              const SizedBox(height: 4.0),
              Text(question.comment!, style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 8.0),
            Text('Type: ${question.type.displayName}', style: Theme.of(context).textTheme.bodySmall),
            if (question.answers.isNotEmpty) ...[
              const SizedBox(height: 4.0),
              Text('Answers: ${question.answers.length}', style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
