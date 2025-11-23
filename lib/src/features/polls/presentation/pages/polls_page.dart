import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../blocs/polls_page/bloc.dart';
import '../widgets/poll_item.dart';
import '../widgets/poll_item_view_model.dart';

class PollsPage extends StatelessWidget {
  const PollsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PollsListBloc, PollsListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Polls')),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PollsListState state) {
    if (state.status == LoadingStatus.loading || state.status == LoadingStatus.initial) {
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
                context.read<PollsListBloc>().add(
                  const PollsListEvent.loadPolls(),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Success state
    final polls = state.polls;
    final coverImages = state.coverImages;

    if (polls.isEmpty) {
      return const Center(child: Text('No polls available'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PollsListBloc>().add(
          const PollsListEvent.refreshPolls(),
        );
      },
      child: ListView.builder(
        itemCount: polls.length,
        itemBuilder: (context, index) {
          final poll = polls[index];
          final viewModel = PollItemViewModel(
            poll: poll,
            coverImage: coverImages[poll.id],
          );
          return PollItem(
            viewModel: viewModel,
            onTap: () {
              context.push('/home/polls/${poll.id}');
            },
          );
        },
      ),
    );
  }
}
