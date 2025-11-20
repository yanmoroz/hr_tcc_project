import 'package:flutter_bloc/flutter_bloc.dart';

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
      super(const ApplicationsListState.initial()) {
    on<LoadApplications>(_onLoadApplications);
    on<RefreshApplications>(_onRefreshApplications);
    on<LoadMoreApplications>(_onLoadMoreApplications);
    on<ChangeStatusFilter>(_onChangeStatusFilter);
  }

  Future<void> _onLoadApplications(
    LoadApplications event,
    Emitter<ApplicationsListState> emit,
  ) async {
    emit(const ApplicationsListState.loading());
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
    // Extract state values first
    List<ApplicationInfo>? applications;
    List<ApplicationStatistics>? statistics;
    int? currentPage;
    bool? hasMorePages;
    bool? isLoadingMore;
    StatusGroupType? statusGroup;
    String? search;

    state.maybeWhen(
      loaded:
          (
            loadedApplications,
            loadedStatistics,
            loadedCurrentPage,
            loadedHasMorePages,
            loadedIsLoadingMore,
            loadedStatusGroup,
            loadedSearch,
          ) {
            applications = loadedApplications;
            statistics = loadedStatistics;
            currentPage = loadedCurrentPage;
            hasMorePages = loadedHasMorePages;
            isLoadingMore = loadedIsLoadingMore;
            statusGroup = loadedStatusGroup;
            search = loadedSearch;
          },
      orElse: () {},
    );

    // Only load more if we're in loaded state and not already loading more
    if (applications != null &&
        currentPage != null &&
        hasMorePages != null &&
        !(isLoadingMore ?? false) &&
        hasMorePages!) {
      // Emit state with isLoadingMore = true
      emit(
        ApplicationsListState.loaded(
          applications: applications!,
          statistics: statistics ?? [],
          currentPage: currentPage!,
          hasMorePages: hasMorePages!,
          isLoadingMore: true,
          statusGroup: statusGroup,
          search: search,
        ),
      );

      // Load next page
      await _loadMoreApplications(
        emit,
        currentApplications: applications!,
        currentStatistics: statistics ?? [],
        nextPage: currentPage! + 1,
        statusGroup: statusGroup,
        search: search,
      );
    }
  }

  Future<void> _onChangeStatusFilter(
    ChangeStatusFilter event,
    Emitter<ApplicationsListState> emit,
  ) async {
    // Extract current search term if in loaded state
    String? currentSearch;
    state.maybeWhen(
      loaded: (_, __, ___, ____, _____, ______, search) {
        currentSearch = search;
      },
      orElse: () {},
    );

    // Reload applications with new filter
    emit(const ApplicationsListState.loading());
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
      (error) => emit(ApplicationsListState.error(error.toString())),
      (result) {
        emit(
          ApplicationsListState.loaded(
            applications: result.applications,
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
        emit(
          ApplicationsListState.loaded(
            applications: currentApplications,
            statistics: currentStatistics,
            currentPage: nextPage - 1,
            hasMorePages: true,
            isLoadingMore: false,
            statusGroup: statusGroup,
            search: search,
          ),
        );
      },
      (result) {
        final allApplications = [
          ...currentApplications,
          ...result.applications,
        ];
        emit(
          ApplicationsListState.loaded(
            applications: allApplications,
            statistics: result.statistics,
            currentPage: nextPage,
            hasMorePages:
                result.applications.length >=
                _pageSize, // No more pages if less than full page
            isLoadingMore: false,
            statusGroup: statusGroup,
            search: search,
          ),
        );
      },
    );
  }
}
