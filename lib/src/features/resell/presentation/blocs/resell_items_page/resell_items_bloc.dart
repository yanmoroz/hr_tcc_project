import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/logging/app_logger.dart';
import '../../../domain/domain.dart';
import 'resell_items_event.dart';
import 'resell_items_state.dart';

class ResellItemsBloc extends Bloc<ResellItemsEvent, ResellItemsState> {
  static const int _pageSize = 20;

  final GetResellItemsUsecase _getResellItemsUsecase;

  ResellItemsBloc(this._getResellItemsUsecase)
    : super(const ResellItemsState()) {
    on<LoadResellItems>(_onLoadResellItems);
    on<LoadMore>(_onLoadMore);
    on<RefreshItems>(_onRefreshItems);
    on<FilterByStatus>(_onFilterByStatus);
    on<ChangeSearchQuery>(_onChangeSearchQuery);
  }

  Future<void> _loadItems(
    Emitter<ResellItemsState> emit,
    int page,
    int status, {
    List<ResellItem>? existingItems,
  }) async {
    final result = await _getResellItemsUsecase(
      status: ResellStatus.fromValue(status),
      search: state.search,
      page: page,
      pageSize: _pageSize,
    );

    if (!emit.isDone) {
      result.fold(
        (error) {
          AppLogger.e('Failed to load resell items: ${error.toString()}');
          if (existingItems != null) {
            // If loading more failed, revert to previous state
            emit(
              state.copyWith(
                items: existingItems,
                currentPage: page - 1,
                hasMorePages: true,
                isLoadingMore: false,
                currentStatus: status,
                filteringStatus: LoadingStatus.success,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: LoadingStatus.error,
                filteringStatus: LoadingStatus.error,
                errorMessage: error.toString(),
              ),
            );
          }
        },
        (result) {
          final allItems = existingItems != null
              ? [...existingItems, ...result.items]
              : result.items;

          emit(
            state.copyWith(
              status: LoadingStatus.success,
              filteringStatus: LoadingStatus.success,
              items: allItems,
              currentPage: page,
              hasMorePages: result.items.length == _pageSize,
              isLoadingMore: false,
              currentStatus: status,
            ),
          );
        },
      );
    }
  }

  Future<void> _loadItemsAndCounts(
    Emitter<ResellItemsState> emit,
    int page,
    int status,
  ) async {
    final currentStatus = ResellStatus.fromValue(status);
    final otherStatus = currentStatus == ResellStatus.onSale
        ? ResellStatus.booked
        : ResellStatus.onSale;

    // Fetch items for current status and count for the other status in parallel
    final results = await Future.wait([
      _getResellItemsUsecase(
        status: currentStatus,
        search: state.search,
        page: page,
        pageSize: _pageSize,
      ),
      _getResellItemsUsecase(status: otherStatus, page: 0, pageSize: _pageSize),
    ]);

    final itemsResult = results[0];
    final otherCountResult = results[1];

    if (!emit.isDone) {
      itemsResult.fold(
        (error) {
          AppLogger.e('Failed to load resell items: ${error.toString()}');
          emit(
            state.copyWith(
              status: LoadingStatus.error,
              filteringStatus: LoadingStatus.error,
              errorMessage: error.toString(),
            ),
          );
        },
        (result) {
          final otherCount = otherCountResult.fold(
            (_) => currentStatus == ResellStatus.onSale
                ? state.totalReserved
                : state.totalOnSale,
            (r) => r.total,
          );

          final totalOnSale = currentStatus == ResellStatus.onSale
              ? result.total
              : otherCount;
          final totalReserved = currentStatus == ResellStatus.booked
              ? result.total
              : otherCount;

          emit(
            state.copyWith(
              status: LoadingStatus.success,
              filteringStatus: LoadingStatus.success,
              items: result.items,
              currentPage: page,
              hasMorePages: result.items.length == _pageSize,
              isLoadingMore: false,
              currentStatus: status,
              totalOnSale: totalOnSale,
              totalReserved: totalReserved,
            ),
          );
        },
      );
    }
  }

  Future<void> _onChangeSearchQuery(
    ChangeSearchQuery event,
    Emitter<ResellItemsState> emit,
  ) async {
    emit(
      state.copyWith(
        filteringStatus: LoadingStatus.loading,
        search: event.query,
      ),
    );
    await _loadItems(emit, 0, state.currentStatus);
  }

  Future<void> _onFilterByStatus(
    FilterByStatus event,
    Emitter<ResellItemsState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadItems(emit, 0, event.status);
  }

  Future<void> _onLoadMore(
    LoadMore event,
    Emitter<ResellItemsState> emit,
  ) async {
    if (state.status != LoadingStatus.success ||
        state.isLoadingMore ||
        !state.hasMorePages) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    await _loadItems(
      emit,
      state.currentPage + 1,
      state.currentStatus,
      existingItems: state.items,
    );
  }

  Future<void> _onLoadResellItems(
    LoadResellItems event,
    Emitter<ResellItemsState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadItemsAndCounts(
      emit,
      0,
      1,
    ); // Default page = 0, status = 1 (On Sale)
  }

  Future<void> _onRefreshItems(
    RefreshItems event,
    Emitter<ResellItemsState> emit,
  ) async {
    final currentStatus = state.currentStatus;

    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadItemsAndCounts(emit, 0, currentStatus);
  }
}
