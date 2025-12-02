import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../users/presentation/widgets/user_profile_header.dart';
import '../blocs/applications_list_page/bloc.dart';
import '../widgets/application_card.dart';
import '../widgets/create_application_button.dart';
import '../widgets/empty_applications_state.dart';
import '../widgets/status_filter_tabs.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ApplicationsListBloc>().add(
        const ApplicationsListEvent.loadMoreApplications(),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UserProfileHeader(),
        Expanded(
          child: BlocBuilder<ApplicationsListBloc, ApplicationsListState>(
            builder: (context, state) {
              if (state.status == LoadingStatus.initial ||
                  state.status == LoadingStatus.loading) {
                return const Center(child: AppProgressIndicator());
              }

              if (state.status == LoadingStatus.error) {
                return NetworkErrorMessageWidget(
                  onRetry: () => context.read<ApplicationsListBloc>().add(
                    const ApplicationsListEvent.loadApplications(),
                  ),
                );
              }

              return _buildSuccessContent(context, state);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessContent(
    BuildContext context,
    ApplicationsListState state,
  ) {
    return Column(
      children: [
        // Status filter tabs
        if (state.statistics.isNotEmpty) ...[
          const SizedBox(height: 8),
          StatusFilterTabs(
            statistics: state.statistics,
            selectedStatusGroup: state.statusGroup,
            onStatusGroupChanged: (newStatusGroup) {
              context.read<ApplicationsListBloc>().add(
                ApplicationsListEvent.changeStatusFilter(newStatusGroup),
              );
            },
          ),
        ],

        // Search bar
        SearchBarWidget(
          hintText: 'Поиск по заявкам',
          isLoading: state.filteringStatus == LoadingStatus.loading,
          onSearchChanged: (query) {
            context.read<ApplicationsListBloc>().add(
              ApplicationsListEvent.changeSearchQuery(
                query.isEmpty ? null : query,
              ),
            );
          },
        ),

        // Main content area or filtering error
        Expanded(
          child: state.filteringStatus == LoadingStatus.error
              ? NetworkErrorMessageWidget(
                  onRetry: () => context.read<ApplicationsListBloc>().add(
                    ApplicationsListEvent.changeSearchQuery(state.search),
                  ),
                )
              : _buildApplicationsList(context, state),
        ),

        // Create application button
        CreateApplicationButton(
          onPressed: () => context.go('/applications/creation'),
        ),
      ],
    );
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
      return const EmptyApplicationsState();
    }

    // Empty results with filters
    if (state.applications.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Заявок не найдено',
            style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
          ),
        ),
      );
    }

    // Application list
    return AppRefreshIndicator(
      onRefresh: () async {
        context.read<ApplicationsListBloc>().add(
          const ApplicationsListEvent.refreshApplications(),
        );
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.applications.length + (state.isLoadingMore ? 1 : 0),
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
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
