import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/value_objects/status_group_type.dart';
import '../../../domain/domain.dart';

import 'applications_list_event.dart';
import 'applications_list_state.dart';

class ApplicationsListBloc
    extends Bloc<ApplicationsListEvent, ApplicationsListState> {
  final GetApplicationsUsecase _getApplicationsUsecase;

  static const int _pageSize = 20;

  ApplicationsListBloc({required GetApplicationsUsecase getApplicationsUsecase})
    : _getApplicationsUsecase = getApplicationsUsecase,
      super(const ApplicationsListState()) {
    on<LoadApplications>(_onLoadApplications);
    on<RefreshApplications>(_onRefreshApplications);
    on<LoadMoreApplications>(_onLoadMoreApplications);
    on<ChangeStatusFilter>(_onChangeStatusFilter);
    on<ChangeSearchQuery>(_onChangeSearchQuery);
  }

  Future<void> _onLoadApplications(
    LoadApplications event,
    Emitter<ApplicationsListState> emit,
  ) async {
    // Initial load - uses full loading state
    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadApplications(emit, page: 0, statusGroup: null, search: null);
  }

  Future<void> _onRefreshApplications(
    RefreshApplications event,
    Emitter<ApplicationsListState> emit,
  ) async {
    // Reload from page 0 using current filters from state
    await _loadApplications(
      emit,
      page: 0,
      statusGroup: state.statusGroup,
      search: state.search,
    );
  }

  Future<void> _onLoadMoreApplications(
    LoadMoreApplications event,
    Emitter<ApplicationsListState> emit,
  ) async {
    // Only load more if we're in success state and not already loading more
    if (state.status != LoadingStatus.success ||
        state.isLoadingMore ||
        !state.hasMorePages) {
      return;
    }

    // Emit state with isLoadingMore = true
    emit(state.copyWith(isLoadingMore: true));

    // Load next page
    await _loadMoreApplications(emit, nextPage: state.currentPage + 1);
  }

  void _onChangeStatusFilter(
    ChangeStatusFilter event,
    Emitter<ApplicationsListState> emit,
  ) {
    // Filter locally - no API call needed
    final filteredApplications = _filterByStatusGroup(
      state.allApplications,
      event.statusGroup,
    );
    emit(
      state.copyWith(
        applications: filteredApplications,
        statusGroup: event.statusGroup,
      ),
    );
  }

  List<ApplicationInfo> _filterByStatusGroup(
    List<ApplicationInfo> applications,
    StatusGroupType? statusGroup,
  ) {
    if (statusGroup == null) {
      return applications;
    }
    return applications
        .where((app) => app.systemStatus.statusGroup == statusGroup)
        .toList();
  }

  Future<void> _onChangeSearchQuery(
    ChangeSearchQuery event,
    Emitter<ApplicationsListState> emit,
  ) async {
    // Use filteringStatus for search changes (keeps content visible)
    emit(state.copyWith(filteringStatus: LoadingStatus.loading));
    await _loadApplications(
      emit,
      page: 0,
      statusGroup: state.statusGroup,
      search: event.query,
    );
  }

  Future<void> _loadApplications(
    Emitter<ApplicationsListState> emit, {
    required int page,
    StatusGroupType? statusGroup,
    String? search,
  }) async {
    final result = await _getApplicationsUsecase(
      page: page,
      pageSize: _pageSize,
      statusGroup: statusGroup,
      search: search,
    );

    final isFiltering = state.filteringStatus == LoadingStatus.loading;

    result.fold(
      (error) {
        if (isFiltering) {
          // Filtering error - keep content visible, show error in filteringStatus
          emit(
            state.copyWith(
              filteringStatus: LoadingStatus.error,
              errorMessage: error.toString(),
            ),
          );
        } else {
          // Initial load error
          emit(
            state.copyWith(
              status: LoadingStatus.error,
              errorMessage: error.toString(),
            ),
          );
        }
      },
      (result) {
        final filteredApplications = _filterByStatusGroup(
          result.applications,
          statusGroup,
        );
        emit(
          state.copyWith(
            status: LoadingStatus.success,
            filteringStatus: LoadingStatus.initial,
            allApplications: result.applications,
            applications: filteredApplications,
            statistics: result.statistics,
            currentPage: page,
            hasMorePages:
                result.applications.length >=
                _pageSize, // Assume more pages if we got full page
            isLoadingMore: false,
            statusGroup: statusGroup,
            search: search,
          ),
        );
      },
    );
  }

  Future<void> _loadMoreApplications(
    Emitter<ApplicationsListState> emit, {
    required int nextPage,
  }) async {
    final result = await _getApplicationsUsecase(
      page: nextPage,
      pageSize: _pageSize,
      statusGroup: null, // Always load all, filter locally
      search: state.search,
    );

    result.fold(
      (error) {
        // On error, just reset isLoadingMore
        emit(state.copyWith(isLoadingMore: false));
      },
      (result) {
        final newAllApplications = [
          ...state.allApplications,
          ...result.applications,
        ];
        final filteredApplications = _filterByStatusGroup(
          newAllApplications,
          state.statusGroup,
        );
        emit(
          state.copyWith(
            allApplications: newAllApplications,
            applications: filteredApplications,
            statistics: result.statistics,
            currentPage: nextPage,
            hasMorePages:
                result.applications.length >=
                _pageSize, // No more pages if less than full page
            isLoadingMore: false,
          ),
        );
      },
    );
  }
}
