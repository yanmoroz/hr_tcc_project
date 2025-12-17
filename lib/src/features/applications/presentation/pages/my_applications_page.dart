import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../blocs/applications_list_page/bloc.dart';
import '../delegates/my_applications_header_delegate.dart';
import '../widgets/application_card.dart';
import '../widgets/empty_applications_state.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
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
        body: BlocBuilder<ApplicationsListBloc, ApplicationsListState>(
          builder: (context, state) {
            return Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: MyApplicationsHeaderDelegate(
                        userBarExtent: 48.0,
                        tabsExtent: state.statistics.isNotEmpty ? 62.0 : 0.0,
                        searchBarExtent: 60.0,
                        collapsedExtent: 8.0,
                        state: state,
                        onStatusGroupChanged: (newStatusGroup) {
                          context.read<ApplicationsListBloc>().add(
                            ApplicationsListEvent.changeStatusFilter(
                              newStatusGroup,
                            ),
                          );
                        },
                        onSearchChanged: (query) {
                          context.read<ApplicationsListBloc>().add(
                            ApplicationsListEvent.changeSearchQuery(
                              query.isEmpty ? null : query,
                            ),
                          );
                        },
                      ),
                    ),
                    SliverRefreshControl(
                      onRefresh: () async {
                        context.read<ApplicationsListBloc>().add(
                          const ApplicationsListEvent.refreshApplications(),
                        );
                      },
                    ),
                    SliverPadding(
                      padding: _calculateEdgeInsets(context, state),
                      sliver: switch (state.status) {
                        LoadingStatus.initial => _buildLoadingState(),
                        LoadingStatus.loading => _buildLoadingState(),
                        LoadingStatus.error => _buildErrorState(context),
                        LoadingStatus.success => _buildLoadedState(
                          context,
                          state,
                        ),
                      },
                    ),
                  ],
                ),
                // Create application button (above list, positioned at bottom)
                _buildCreateApplicationButton(context),
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

  Widget _buildApplicationsList(
    BuildContext context,
    ApplicationsListState state,
  ) {
    // Check if we have no applications and no filters applied
    final hasNoApplications =
        state.applications.isEmpty &&
        state.statusGroup == null &&
        (state.search == null || state.search!.isEmpty);

    if (hasNoApplications) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: const EmptyApplicationsState(),
      );
    }

    // Empty results with filters
    if (state.applications.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'Заявок не найдено',
            style: AppTypography.textRegular1.black,
          ),
        ),
      );
    }

    // Application list
    return SliverList.separated(
      itemCount: state.applications.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index >= state.applications.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: AppProgressIndicator(),
            ),
          );
        }

        final application = state.applications[index];
        return ApplicationCard(
          application: application,
          onTap: () => context.push('/applications/${application.id}'),
        );
      },
    );
  }

  Widget _buildCreateApplicationButton(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: SafeArea(
        child: PrimaryButton(
          label: 'Создать заявку',
          size: PrimaryButtonSize.large,
          style: PrimatyButtonStyle.colored,
          onPressed: () => context.go('/applications/creation'),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: NetworkErrorMessageWidget(
        onRetry: () => context.read<ApplicationsListBloc>().add(
          const ApplicationsListEvent.loadApplications(),
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, ApplicationsListState state) {
    return state.filteringStatus == LoadingStatus.error
        ? SliverFillRemaining(
            hasScrollBody: false,
            child: NetworkErrorMessageWidget(
              onRetry: () => context.read<ApplicationsListBloc>().add(
                ApplicationsListEvent.changeSearchQuery(state.search),
              ),
            ),
          )
        : _buildApplicationsList(context, state);
  }

  Widget _buildLoadingState() {
    return SliverShimmeringList(spacing: 8, maxHeight: 90);
  }

  EdgeInsets _calculateEdgeInsets(
    BuildContext context,
    ApplicationsListState state,
  ) {
    const topPadding = 16.0;
    final bottomPadding = 16.0 + PrimaryButtonSize.large.height + 16;
    return EdgeInsets.fromLTRB(16, topPadding, 16, bottomPadding);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ApplicationsListBloc>().add(
        const ApplicationsListEvent.loadMoreApplications(),
      );
    }
  }
}
