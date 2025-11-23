import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/value_objects/status_group_type.dart';
import '../../../../core/widgets/search_bar_widget.dart';
import '../../../users/presentation/widgets/user_profile_header.dart';
import '../../domain/domain.dart';
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
        // Status filter tabs - only rebuilds when statistics or selected filter changes
        BlocSelector<ApplicationsListBloc, ApplicationsListState,
            _FilterTabsState>(
          selector: (state) {
            if (state.status == LoadingStatus.success) {
              return _FilterTabsState(
                statistics: state.statistics,
                selectedStatusGroup: state.statusGroup,
              );
            }
            return const _FilterTabsState(
              statistics: [],
              selectedStatusGroup: null,
            );
          },
          builder: (context, filterTabsState) {
            if (filterTabsState.statistics.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                const SizedBox(height: 8),
                StatusFilterTabs(
                  statistics: filterTabsState.statistics,
                  selectedStatusGroup: filterTabsState.selectedStatusGroup,
                  onStatusGroupChanged: (newStatusGroup) {
                    context.read<ApplicationsListBloc>().add(
                      ApplicationsListEvent.changeStatusFilter(newStatusGroup),
                    );
                  },
                ),
              ],
            );
          },
        ),

        // Search bar - never rebuilds on state changes
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: BlocSelector<ApplicationsListBloc, ApplicationsListState,
              _SearchBarState>(
            selector: (state) {
              return _SearchBarState(statusGroup: state.statusGroup);
            },
            builder: (context, searchBarState) {
              return SearchBarWidget(
                hintText: 'Поиск по заявкам',
                onSearchChanged: (query) {
                  context.read<ApplicationsListBloc>().add(
                        ApplicationsListEvent.loadApplications(
                          search: query.isEmpty ? null : query,
                          statusGroup: searchBarState.statusGroup,
                        ),
                      );
                },
              );
            },
          ),
        ),

        // Main content area
        Expanded(
          child: BlocBuilder<ApplicationsListBloc, ApplicationsListState>(
            builder: (context, state) {
              if (state.status == LoadingStatus.initial ||
                  state.status == LoadingStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == LoadingStatus.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Color(0xFF757575),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ошибка загрузки',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          state.errorMessage ?? 'Unknown error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ApplicationsListBloc>().add(
                                const ApplicationsListEvent.loadApplications(),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                );
              }

              // Check if we have no applications and no filters applied
              final hasNoApplications = state.applications.isEmpty &&
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
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ),
                );
              }

              // Application list
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ApplicationsListBloc>().add(
                        ApplicationsListEvent.refreshApplications(
                          statusGroup: state.statusGroup,
                          search: state.search,
                        ),
                      );
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.applications.length +
                      (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.applications.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final application = state.applications[index];
                    return ApplicationCard(
                      application: application,
                      onTap: () {
                        // Navigate to application detail page
                        context.push('/applications/${application.id}');
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),

        // Create application button - always visible
        CreateApplicationButton(
          onPressed: () {
            context.push('/applications/creation');
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// Helper classes for BlocSelector to prevent unnecessary rebuilds

class _SearchBarState {
  final StatusGroupType? statusGroup;

  const _SearchBarState({required this.statusGroup});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _SearchBarState &&
          runtimeType == other.runtimeType &&
          statusGroup == other.statusGroup;

  @override
  int get hashCode => statusGroup.hashCode;
}

class _FilterTabsState {
  final List<ApplicationStatistics> statistics;
  final StatusGroupType? selectedStatusGroup;

  const _FilterTabsState({
    required this.statistics,
    required this.selectedStatusGroup,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _FilterTabsState &&
          runtimeType == other.runtimeType &&
          statistics == other.statistics &&
          selectedStatusGroup == other.selectedStatusGroup;

  @override
  int get hashCode => statistics.hashCode ^ selectedStatusGroup.hashCode;
}
