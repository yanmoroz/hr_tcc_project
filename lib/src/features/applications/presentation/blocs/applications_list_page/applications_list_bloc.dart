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
  }

  Future<void> _onLoadApplications(
    LoadApplications event,
    Emitter<ApplicationsListState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadApplications(
      emit,
      page: 0,
      statusGroup: event.statusGroup,
      search: event.search,
    );
  }

  Future<void> _onRefreshApplications(
    RefreshApplications event,
    Emitter<ApplicationsListState> emit,
  ) async {
    // Reload from page 0
    await _loadApplications(
      emit,
      page: 0,
      statusGroup: event.statusGroup,
      search: event.search,
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
    await _loadMoreApplications(
      emit,
      currentApplications: state.applications,
      currentStatistics: state.statistics,
      nextPage: state.currentPage + 1,
      statusGroup: state.statusGroup,
      search: state.search,
    );
  }

  Future<void> _onChangeStatusFilter(
    ChangeStatusFilter event,
    Emitter<ApplicationsListState> emit,
  ) async {
    // Extract current search term
    final currentSearch = state.search;

    // Reload applications with new filter
    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadApplications(
      emit,
      page: 0,
      statusGroup: event.statusGroup,
      search: currentSearch,
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

    result.fold(
      (error) => emit(state.copyWith(
        status: LoadingStatus.error,
        errorMessage: error.toString(),
      )),
      (result) {
        emit(state.copyWith(
          status: LoadingStatus.success,
          applications: result.applications,
          statistics: result.statistics,
          currentPage: page,
          hasMorePages:
              result.applications.length >=
              _pageSize, // Assume more pages if we got full page
          isLoadingMore: false,
          statusGroup: statusGroup,
          search: search,
        ));
      },
    );
  }

  Future<void> _loadMoreApplications(
    Emitter<ApplicationsListState> emit, {
    required List<ApplicationInfo> currentApplications,
    required List<ApplicationStatistics> currentStatistics,
    required int nextPage,
    StatusGroupType? statusGroup,
    String? search,
  }) async {
    final result = await _getApplicationsUsecase(
      page: nextPage,
      pageSize: _pageSize,
      statusGroup: statusGroup,
      search: search,
    );

    result.fold(
      (error) {
        // On error, revert to previous state without isLoadingMore
        emit(state.copyWith(
          applications: currentApplications,
          statistics: currentStatistics,
          currentPage: nextPage - 1,
          hasMorePages: true,
          isLoadingMore: false,
          statusGroup: statusGroup,
          search: search,
        ));
      },
      (result) {
        final allApplications = [
          ...currentApplications,
          ...result.applications,
        ];
        emit(state.copyWith(
          applications: allApplications,
          statistics: result.statistics,
          currentPage: nextPage,
          hasMorePages:
              result.applications.length >=
              _pageSize, // No more pages if less than full page
          isLoadingMore: false,
          statusGroup: statusGroup,
          search: search,
        ));
      },
    );
  }
}
