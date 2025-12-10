import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../g2g/users/presentation/widgets/user_info_bar.dart';
import '../blocs/applications_list_page/bloc.dart';
import '../widgets/application_card.dart';
import '../widgets/empty_applications_state.dart';
import '../widgets/status_filter_tabs.dart';

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
        body: Column(
          children: [
            const UserInfoBar(),
            Expanded(
              child: BlocBuilder<ApplicationsListBloc, ApplicationsListState>(
                builder: (context, state) {
                  return switch (state.status) {
                    LoadingStatus.initial => _buildLoadingState(context),
                    LoadingStatus.loading => _buildLoadingState(context),
                    LoadingStatus.error => _buildErrorState(context),
                    LoadingStatus.success => _buildLoadedState(context, state),
                  };
                },
              ),
            ),
          ],
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
      return const EmptyApplicationsState();
    }

    // Empty results with filters
    if (state.applications.isEmpty) {
      return Center(
        child: Text(
          'Заявок не найдено',
          style: AppTypography.textRegular1.black,
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
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount:
                  state.applications.length + (state.isLoadingMore ? 1 : 0),
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
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return NetworkErrorMessageWidget(
      onRetry: () => context.read<ApplicationsListBloc>().add(
        const ApplicationsListEvent.loadApplications(),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, ApplicationsListState state) {
    return Stack(
      children: [
        // Main content
        Column(
          children: [
            // Status filter tabs
            if (state.statistics.isNotEmpty) ...[
              Container(
                color: AppColors.white,
                child: StatusFilterTabs(
                  statistics: state.statistics,
                  selectedStatusGroup: state.statusGroup,
                  onStatusGroupChanged: (newStatusGroup) {
                    context.read<ApplicationsListBloc>().add(
                      ApplicationsListEvent.changeStatusFilter(newStatusGroup),
                    );
                  },
                ),
              ),
            ],

            // Search bar
            Container(
              color: AppColors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SearchBarWidget(
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
              ),
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
          ],
        ),

        // Create application button (bottom)
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/applications/creation'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.blue700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Создать заявку',
                  style: AppTypography.buttonMedium1.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildLoadingState(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Shimmer.fromColors(
              baseColor: AppColors.grey200,
              highlightColor: AppColors.grey100,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(height: 36, width: double.infinity),
              ),
            ),
          ),
        ),
        Container(
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Shimmer.fromColors(
              baseColor: AppColors.grey200,
              highlightColor: AppColors.grey100,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(height: 40, width: double.infinity),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: AppColors.grey200,
                      highlightColor: AppColors.grey100,
                      child: Container(
                        width: double.infinity,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.grey200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: 10,
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ApplicationsListBloc>().add(
        const ApplicationsListEvent.loadMoreApplications(),
      );
    }
  }
}
