import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/delegates/delegates.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../blocs/polls_page/bloc.dart';
import '../widgets/poll_item.dart';
import '../widgets/poll_item_view_model.dart';

class PollsPage extends StatefulWidget {
  const PollsPage({super.key});

  @override
  State<PollsPage> createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  final ScrollController _scrollController = ScrollController();

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        appBar: AppBar(
          title: BlocSelector<PollsListBloc, PollsListState, int>(
            selector: (state) => state.totalAll,
            builder: (context, totalCount) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Опросы'),
                  if (totalCount > 0)
                    Text(
                      '$totalCount опросов',
                      style: AppTypography.textRegular2.grey700,
                    )
                  else
                    const SizedBox(height: 18),
                ],
              );
            },
          ),
        ),
        body: BlocBuilder<PollsListBloc, PollsListState>(
          builder: (context, state) {
            final currentStatus = state.currentStatus;

            return CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: FiltersAndSearchBarsHeaderDelegate(
                    filtersBar: FiltersBar<int?>(
                      items: [
                        FilterItem(
                          value: null,
                          label: 'Все',
                          count: state.totalAll,
                        ),
                        FilterItem(
                          value: 1,
                          label: 'Непройденные',
                          count: state.totalNotPassed,
                        ),
                        FilterItem(
                          value: 2,
                          label: 'Пройденные',
                          count: state.totalPassed,
                        ),
                      ],
                      selectedValue: currentStatus,
                      onFilterChanged: (value) {
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(0);
                        }
                        context.read<PollsListBloc>().add(
                          PollsListEvent.filterByStatus(value),
                        );
                      },
                    ),
                    filtersExtent: 62.0,
                    searchBarExtent: 0.0,
                    collapsedExtent: 0.0,
                    searchHint: '',
                    onSearchChanged: (_) {},
                  ),
                ),
                SliverRefreshControl(
                  onRefresh: () async {
                    context.read<PollsListBloc>().add(
                      const PollsListEvent.refreshPolls(),
                    );
                  },
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: _buildContent(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Widget _buildContent(BuildContext context, PollsListState state) {
    if (state.status == LoadingStatus.loading ||
        state.status == LoadingStatus.initial) {
      return SliverShimmeringList(spacing: 8, maxHeight: 120);
    }

    if (state.status == LoadingStatus.error) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: NetworkErrorMessageWidget(
          onRetry: () => context.read<PollsListBloc>().add(
            const PollsListEvent.loadPolls(),
          ),
        ),
      );
    }

    // Success state
    final polls = state.polls;

    if (polls.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('Нет опросов', style: AppTypography.textRegular1.black),
        ),
      );
    }

    return SliverList.separated(
      itemCount: polls.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index >= polls.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: AppProgressIndicator(),
            ),
          );
        }

        final poll = polls[index];
        final viewModel = PollItemViewModel(
          poll: poll,
          coverImage: state.coverImages[poll.id],
        );
        return PollItem(
          viewModel: viewModel,
          onTap: () {
            context.push('/home/polls/${poll.id}');
          },
        );
      },
    );
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PollsListBloc>().add(const PollsListEvent.loadMore());
    }
  }
}
