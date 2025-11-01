import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../bloc/polls_page/polls_list_bloc.dart';
import '../bloc/polls_page/polls_list_event.dart';
import '../bloc/polls_page/polls_list_state.dart';
import '../widgets/poll_item.dart';

class PollsPage extends StatelessWidget {
  const PollsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PollsListBloc>()..add(const PollsListEvent.loadPolls()),
      child: BlocBuilder<PollsListBloc, PollsListState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Polls')),
            body: state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (polls) {
                if (polls.isEmpty) {
                  return const Center(child: Text('No polls available'));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<PollsListBloc>().add(const PollsListEvent.refreshPolls());
                  },
                  child: ListView.builder(
                    itemCount: polls.length,
                    itemBuilder: (context, index) {
                      final poll = polls[index];
                      return PollItem(
                        poll: poll,
                        onTap: () {
                          Navigator.pushNamed(context, '/poll', arguments: poll.id);
                        },
                      );
                    },
                  ),
                );
              },
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $message', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PollsListBloc>().add(const PollsListEvent.loadPolls());
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
}
